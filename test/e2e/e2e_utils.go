package e2e

import (
	"context"
	"crypto/tls"
	"encoding/base64"
	"fmt"
	"io"
	"io/fs"
	"net/http"
	"os"
	"os/signal"
	"path"
	"path/filepath"
	"syscall"
	"time"

	dcontext "github.com/distribution/distribution/v3/context"
	storagedriver "github.com/distribution/distribution/v3/registry/storage/driver"
	"github.com/onsi/ginkgo"

	"github.com/ipfs/go-datastore"
	syncds "github.com/ipfs/go-datastore/sync"
	"github.com/ipfs/go-filestore"
	files "github.com/ipfs/go-ipfs-files"
	keystore "github.com/ipfs/go-ipfs-keystore"
	config "github.com/ipfs/go-ipfs/config"
	"github.com/ipfs/go-ipfs/core"
	"github.com/ipfs/go-ipfs/core/bootstrap"
	"github.com/ipfs/go-ipfs/core/coreapi"
	mock "github.com/ipfs/go-ipfs/core/mock"
	"github.com/ipfs/go-ipfs/core/node/libp2p"
	"github.com/ipfs/go-ipfs/repo"
	coreiface "github.com/ipfs/interface-go-ipfs-core"
	crypto "github.com/libp2p/go-libp2p-core/crypto"
	peer "github.com/libp2p/go-libp2p-core/peer"
	mocknet "github.com/libp2p/go-libp2p/p2p/net/mock"
	"github.com/sirupsen/logrus"
	ipfsdriver "github.com/yuval-k/oci-registry-p2p/registry/storage/driver/ipfs"

	"github.com/distribution/distribution/v3/configuration"
	"github.com/distribution/distribution/v3/registry/handlers"
	"github.com/distribution/distribution/v3/registry/listener"
	"github.com/distribution/distribution/v3/uuid"
)

func ToIpfsDir(filesys fs.FS, name string) files.Directory {
	return &fsDirectory{name: name, filesys: filesys}
}

type fsDirectory struct {
	name    string
	filesys fs.FS
}

func (f *fsDirectory) Close() error {
	return nil
}

// Size returns size of this file (if this file is a directory, total size of
// all files stored in the tree should be returned). Some implementations may
// choose not to implement this
func (f *fsDirectory) Size() (int64, error) {
	var size int64
	it := f.Entries()
	for it.Next() {
		s, err := it.Node().Size()
		if err != nil {
			return 0, err
		}
		size += s
	}
	if it.Err() != nil {
		return 0, it.Err()
	}
	return size, nil
}

// Entries returns a stateful iterator over directory entries.
//
// Example usage:
//
// it := dir.Entries()
// for it.Next() {
//   name := it.Name()
//   file := it.Node()
//   [...]
// }
// if it.Err() != nil {
//   return err
// }
//
// Note that you can't store the result of it.Node() and use it after
// advancing the iterator
func (f *fsDirectory) Entries() files.DirIterator {
	entries, err := fs.ReadDir(f.filesys, f.name)
	return &fsDirIterator{
		parent: f,
		files:  entries,
		err:    err,
		n:      -1,
	}
}

type fsDirIterator struct {
	parent *fsDirectory
	files  []fs.DirEntry
	n      int
	err    error
}

func (it *fsDirIterator) Name() string {
	return it.files[it.n].Name()
}

func (it *fsDirIterator) Node() files.Node {
	ent := it.files[it.n]
	filePath := path.Join(it.parent.name, ent.Name())
	if ent.IsDir() {
		return ToIpfsDir(it.parent.filesys, filePath)
	}
	file, err := it.parent.filesys.Open(filePath)
	if err != nil {
		it.err = err
		return nil
	}
	return &fsFile{f: file}
}

func (it *fsDirIterator) Next() bool {
	if it.err != nil {
		return false
	}
	it.n++
	return it.n < len(it.files)
}

func (it *fsDirIterator) Err() error {
	return it.err
}

type fsFile struct {
	f fs.File
}

func (f *fsFile) Close() error {
	return f.f.Close()
}

// Size returns size of this file (if this file is a directory, total size of
// all files stored in the tree should be returned). Some implementations may
// choose not to implement this
func (f *fsFile) Size() (int64, error) {
	si, err := f.f.Stat()
	if err != nil {
		return 0, err
	}
	return si.Size(), nil
}

func (f *fsFile) Read(p []byte) (n int, err error) {
	return f.f.Read(p)
}

func (f *fsFile) Seek(offset int64, whence int) (int64, error) {
	if seeker, ok := f.f.(io.Seeker); ok {
		return seeker.Seek(offset, whence)
	}
	return 0, fmt.Errorf("not implemented")
}

// I created this test factory so i can better control the create code
// for example, pass context to the driver, so i can cancel it for the
// restart test.
type TestDriverFactory struct {
	Api              coreiface.CoreAPI
	IpnsKey          string
	IpnsReadOnlyKeys []string
	Ctx              context.Context
	driver           *ipfsdriver.IpfsDriver
}

func (s *TestDriverFactory) Create(parameters map[string]interface{}) (storagedriver.StorageDriver, error) {
	var err error
	s.driver, err = ipfsdriver.NewDriverFromAPI(s.Ctx, s.Api, s.IpnsKey, s.IpnsReadOnlyKeys)
	go func() {
		defer ginkgo.GinkgoRecover()
		<-s.Ctx.Done()
		s.driver.Close()
	}()
	return ipfsdriver.Wrap(s.driver), err
}

// this function is in a test package in ipfs, so i copy pasted it here with minor modifications
func MakeAPISwarm(ctx context.Context) ([]coreiface.CoreAPI, func(), error) {
	// note that for ipns publish to work, we need more than one node.
	n := 5
	fullIdentity := true
	mn := mocknet.New()

	nodes := make([]*core.IpfsNode, n)
	apis := make([]coreiface.CoreAPI, n)

	for i := 0; i < n; i++ {
		var ident config.Identity
		sk, pk, err := crypto.GenerateKeyPair(crypto.RSA, 2048)
		if err != nil {
			return nil, nil, err
		}

		id, err := peer.IDFromPublicKey(pk)
		if err != nil {
			return nil, nil, err
		}

		kbytes, err := crypto.MarshalPrivateKey(sk)
		if err != nil {
			return nil, nil, err
		}

		ident = config.Identity{
			PeerID:  id.Pretty(),
			PrivKey: base64.StdEncoding.EncodeToString(kbytes),
		}

		c := config.Config{}
		c.Addresses.Swarm = []string{fmt.Sprintf("/ip4/127.0.0.1/tcp/400%d", i+1)}
		c.Addresses.API = []string{"/ip4/127.0.0.1/tcp/0"}
		c.Identity = ident
		c.Experimental.FilestoreEnabled = true

		ds := syncds.MutexWrap(datastore.NewMapDatastore())
		r := &repo.Mock{
			C: c,
			D: ds,
			K: keystore.NewMemKeystore(),
			F: filestore.NewFileManager(ds, filepath.Dir(os.TempDir())),
		}

		node, err := core.NewNode(ctx, &core.BuildCfg{
			Routing:   libp2p.DHTServerOption,
			Repo:      r,
			Host:      mock.MockHostOption(mn),
			Online:    fullIdentity,
			ExtraOpts: map[string]bool{
				//		"pubsub": true,
			},
		})
		if err != nil {
			return nil, nil, err
		}
		nodes[i] = node
		apis[i], err = coreapi.NewCoreAPI(node)
		if err != nil {
			return nil, nil, err
		}
	}

	err := mn.LinkAll()
	if err != nil {
		return nil, nil, err
	}

	bsinf := bootstrap.BootstrapConfigWithPeers(
		[]peer.AddrInfo{
			nodes[0].Peerstore.PeerInfo(nodes[0].Identity),
		},
	)

	for _, n := range nodes[1:] {
		if err := n.Bootstrap(bsinf); err != nil {
			return nil, nil, err
		}
	}

	return apis, func() {
		for _, n := range nodes {
			n.Close()
		}
	}, nil
}

// there is no good way of stopping docker registry, So i copied a simplified version of it and added shutdown method.
type TestRegistry struct {
	config *configuration.Configuration
	app    *handlers.App
	server *http.Server
}

// NewRegistry creates a new registry from a context and configuration struct.
func NewRegistry(ctx context.Context, config *configuration.Configuration) (*TestRegistry, error) {
	logrus.SetLevel(logrus.DebugLevel)
	logrus.SetFormatter(&logrus.TextFormatter{
		TimestampFormat: time.RFC3339Nano,
	})

	ctx = dcontext.WithLogger(ctx, dcontext.GetLogger(ctx))
	dcontext.SetDefaultLogger(dcontext.GetLogger(ctx))

	// inject a logger into the uuid library. warns us if there is a problem
	// with uuid generation under low entropy.
	uuid.Loggerf = dcontext.GetLogger(ctx).Warnf

	app := handlers.NewApp(ctx, config)

	server := &http.Server{
		Handler: app,
	}

	return &TestRegistry{
		app:    app,
		config: config,
		server: server,
	}, nil
}

func (registry *TestRegistry) Shutdown() error {
	return registry.server.Shutdown(context.Background())
}

// ListenAndServe runs the registry's HTTP server.
func (registry *TestRegistry) ListenAndServe() error {
	config := registry.config

	ln, err := listener.NewListener(config.HTTP.Net, config.HTTP.Addr)
	if err != nil {
		return err
	}
	if config.HTTP.TLS.Certificate != "" || config.HTTP.TLS.LetsEncrypt.CacheFile != "" {

		dcontext.GetLogger(registry.app).Infof("restricting TLS version to %s or higher", config.HTTP.TLS.MinimumTLS)

		tlsCipherSuites := []uint16{
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_CHACHA20_POLY1305_SHA256,
			tls.TLS_AES_256_GCM_SHA384,
		}

		tlsConf := &tls.Config{
			ClientAuth:               tls.NoClientCert,
			NextProtos:               []string{"h2", "http/1.1"},
			MinVersion:               tls.VersionTLS12,
			PreferServerCipherSuites: true,
			CipherSuites:             tlsCipherSuites,
		}
		tlsConf.Certificates = make([]tls.Certificate, 1)
		tlsConf.Certificates[0], err = tls.LoadX509KeyPair(config.HTTP.TLS.Certificate, config.HTTP.TLS.Key)
		if err != nil {
			return err
		}

		ln = tls.NewListener(ln, tlsConf)
		dcontext.GetLogger(registry.app).Infof("listening on %v, tls", ln.Addr())
	} else {
		dcontext.GetLogger(registry.app).Infof("listening on %v", ln.Addr())
	}

	if config.HTTP.DrainTimeout == 0 {
		return registry.server.Serve(ln)
	}

	// setup channel to get notified on SIGTERM signal
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGTERM)
	serveErr := make(chan error)

	// Start serving in goroutine and listen for stop signal in main thread
	go func() {
		defer ginkgo.GinkgoRecover()
		serveErr <- registry.server.Serve(ln)
	}()

	select {
	case err := <-serveErr:
		return err
	case <-quit:
		dcontext.GetLogger(registry.app).Info("stopping server gracefully. Draining connections for ", config.HTTP.DrainTimeout)
		// shutdown the server with a grace period of configured timeout
		c, cancel := context.WithTimeout(context.Background(), config.HTTP.DrainTimeout)
		defer cancel()
		return registry.server.Shutdown(c)
	}
}
