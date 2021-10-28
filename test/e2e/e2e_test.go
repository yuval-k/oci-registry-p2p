package e2e_test

import (
	"context"
	"crypto/tls"
	"encoding/base64"
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"syscall"
	"time"

	dcontext "github.com/distribution/distribution/v3/context"
	storagedriver "github.com/distribution/distribution/v3/registry/storage/driver"
	"github.com/distribution/distribution/v3/registry/storage/driver/factory"

	"github.com/ipfs/go-datastore"
	syncds "github.com/ipfs/go-datastore/sync"
	"github.com/ipfs/go-filestore"
	config "github.com/ipfs/go-ipfs-config"
	keystore "github.com/ipfs/go-ipfs-keystore"
	"github.com/ipfs/go-ipfs/core"
	"github.com/ipfs/go-ipfs/core/bootstrap"
	"github.com/ipfs/go-ipfs/core/coreapi"
	mock "github.com/ipfs/go-ipfs/core/mock"
	"github.com/ipfs/go-ipfs/core/node/libp2p"
	"github.com/ipfs/go-ipfs/repo"
	coreiface "github.com/ipfs/interface-go-ipfs-core"
	options "github.com/ipfs/interface-go-ipfs-core/options"
	crypto "github.com/libp2p/go-libp2p-core/crypto"
	peer "github.com/libp2p/go-libp2p-core/peer"
	mocknet "github.com/libp2p/go-libp2p/p2p/net/mock"
	"github.com/sirupsen/logrus"
	ipfsdriver "github.com/yuval-k/oci-registry-p2p/registry/storage/driver/ipfs"

	"github.com/distribution/distribution/v3/configuration"
	"github.com/distribution/distribution/v3/registry/handlers"
	"github.com/distribution/distribution/v3/registry/listener"
	"github.com/distribution/distribution/v3/uuid"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var (
	i                = 0
	ContainerRuntime = "podman"
)

var _ = Describe("E2e", func() {
	var (
		ctx    context.Context
		cancel context.CancelFunc
		//node       *ipfscore.IpfsNode
		api        coreiface.CoreAPI
		driverName string
		config     *configuration.Configuration
		wait       chan struct{}
		reg        *testRegistry
		ipnsKey    string
		closeNodes func()

		tdf *testDriverFactory
	)
	BeforeEach(func() {
		ctx, cancel = context.WithCancel(context.Background())
		var err error

		apis, cn, err := MakeAPISwarm(ctx)
		Expect(err).NotTo(HaveOccurred())
		closeNodes = cn

		api = apis[0]
		Expect(err).NotTo(HaveOccurred())

		// create test key for us.
		name := "testkey"
		key, err := api.Key().Generate(context.TODO(), name, options.Key.Type("rsa"), options.Key.Size(2048))
		Expect(err).NotTo(HaveOccurred())
		ipnsKey = key.ID().Pretty()

		logrus.SetOutput(GinkgoWriter)
	})

	runRegistry := func() {
		wait = make(chan struct{})
		var err error

		i++
		driverName = fmt.Sprintf("%s%d", ipfsdriver.DriverName, i)

		tdf = &testDriverFactory{
			api:     api,
			ipnsKey: ipnsKey,
			ctx:     ctx,
		}
		// register factory...
		factory.Register(driverName, tdf)

		fp, err := os.Open("config.yaml")
		Expect(err).NotTo(HaveOccurred())

		defer fp.Close()

		config, err = configuration.Parse(fp)
		Expect(err).NotTo(HaveOccurred())

		config.Storage[driverName] = config.Storage[ipfsdriver.DriverName]
		delete(config.Storage, ipfsdriver.DriverName)

		reg, err = NewRegistry(ctx, config)
		Expect(err).NotTo(HaveOccurred())
		go func() {
			defer GinkgoRecover()
			reg.ListenAndServe()
			close(wait)
		}()
	}
	stopRegistry := func() {
		if reg == nil {
			return
		}

		reg.Shutdown()

		cancel()
		ctx, cancel = context.WithCancel(context.Background())
		<-wait
		time.Sleep(time.Second)
	}

	JustBeforeEach(runRegistry)

	AfterEach(func() {
		cancel()
		if closeNodes != nil {
			closeNodes()
		}
		stopRegistry()
	})

	It("should push and pull image", func() {
		cmd := exec.Command(ContainerRuntime, "push", "localhost:5000/alpine", "--tls-verify=false")
		cmd.Stdout = GinkgoWriter
		cmd.Stderr = GinkgoWriter
		err := cmd.Run()
		Expect(err).NotTo(HaveOccurred())
		err = exec.Command(ContainerRuntime, "pull", "localhost:5000/alpine", "--tls-verify=false").Run()
		Expect(err).NotTo(HaveOccurred())
	})

	Context("ipns self", func() {

		BeforeEach(func() {
			ipnsKey = "self"
		})

		It("should push and pull image", func() {
			cmd := exec.Command(ContainerRuntime, "push", "localhost:5000/alpine", "--tls-verify=false")
			cmd.Stdout = GinkgoWriter
			cmd.Stderr = GinkgoWriter
			err := cmd.Run()
			Expect(err).NotTo(HaveOccurred())
			err = exec.Command(ContainerRuntime, "pull", "localhost:5000/alpine", "--tls-verify=false").Run()
			Expect(err).NotTo(HaveOccurred())
		})
	})

	Context("publish survies restart", func() {
		It("should push and pull image", func() {
			cmd := exec.Command(ContainerRuntime, "push", "localhost:5000/alpine", "--tls-verify=false")
			cmd.Stdout = GinkgoWriter
			cmd.Stderr = GinkgoWriter
			err := cmd.Run()
			Expect(err).NotTo(HaveOccurred())

			// give time for the registry to flush data and save the new root
			time.Sleep(time.Second * 5)
			// restart registry to make sure it persisted
			By("restarting the registry")
			stopRegistry()
			runRegistry()
			cmd = exec.Command(ContainerRuntime, "pull", "localhost:5000/alpine", "--tls-verify=false")
			cmd.Stdout = GinkgoWriter
			cmd.Stderr = GinkgoWriter
			err = cmd.Run()
			Expect(err).NotTo(HaveOccurred())
		})
	})

})

var _ = BeforeSuite(func() {

	if os.Getenv("USE_DOCKER") == "1" {
		ContainerRuntime = "docker"
	}

	cmd := exec.Command(ContainerRuntime, "pull", "docker.io/library/alpine:3.10.1")
	cmd.Stdout = GinkgoWriter
	cmd.Stderr = GinkgoWriter
	cmd.Run()
	cmd = exec.Command(ContainerRuntime, "tag", "docker.io/library/alpine:3.10.1", "localhost:5000/alpine")
	cmd.Stdout = GinkgoWriter
	cmd.Stderr = GinkgoWriter
	cmd.Run()
})

// I created thsi test factory so i can better control the create code
// for example, pass context to the driver, so i can cancel it for the
// restart test.
type testDriverFactory struct {
	api     coreiface.CoreAPI
	ipnsKey string
	ctx     context.Context
	driver  *ipfsdriver.IpfsDriver
}

func (s *testDriverFactory) Create(parameters map[string]interface{}) (storagedriver.StorageDriver, error) {
	var err error
	s.driver, err = ipfsdriver.NewDriverFromAPI(s.ctx, s.api, s.ipnsKey, false)
	go func() {
		defer GinkgoRecover()
		<-s.ctx.Done()
		s.driver.Close()
	}()
	return ipfsdriver.Wrap(s.driver), err
}

// this function is in a test package in ipfs, so i copy pasted it here with minor modifications
func MakeAPISwarm(ctx context.Context) ([]coreiface.CoreAPI, func(), error) {
	// note that for ipns publish to work, we need more than one node.
	n := 5
	fullIdentity := true
	mn := mocknet.New(ctx)

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
type testRegistry struct {
	config *configuration.Configuration
	app    *handlers.App
	server *http.Server
}

// NewRegistry creates a new registry from a context and configuration struct.
func NewRegistry(ctx context.Context, config *configuration.Configuration) (*testRegistry, error) {
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

	return &testRegistry{
		app:    app,
		config: config,
		server: server,
	}, nil
}

func (registry *testRegistry) Shutdown() error {
	return registry.server.Shutdown(context.Background())
}

// ListenAndServe runs the registry's HTTP server.
func (registry *testRegistry) ListenAndServe() error {
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
		defer GinkgoRecover()
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
