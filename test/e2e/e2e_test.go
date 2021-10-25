package e2e_test

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"reflect"
	"unsafe"

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
	ci "github.com/libp2p/go-libp2p-core/crypto"
	crypto "github.com/libp2p/go-libp2p-core/crypto"
	peer "github.com/libp2p/go-libp2p-core/peer"
	mocknet "github.com/libp2p/go-libp2p/p2p/net/mock"
	"github.com/sirupsen/logrus"
	ipfsdriver "github.com/yuval-k/oci-registry-p2p/registry/storage/driver/ipfs"

	"github.com/distribution/distribution/v3/configuration"
	"github.com/distribution/distribution/v3/registry"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var (
	i = 0
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
		reg        *registry.Registry
		closeNodes func()

		tdf *testDriverFactory
	)
	BeforeEach(func() {
		i++
		driverName = fmt.Sprintf("%s%d", ipfsdriver.DriverName, i)
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
		ipnsKey := key.ID().Pretty()

		tdf = &testDriverFactory{
			api:     api,
			ipnsKey: ipnsKey,
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

		logrus.SetOutput(GinkgoWriter)

	})

	runRegistry := func() {
		wait = make(chan struct{})
		var err error
		reg, err = registry.NewRegistry(ctx, config)
		Expect(err).NotTo(HaveOccurred())

		go func() {
			reg.ListenAndServe()
			close(wait)
		}()
	}
	stopRegistry := func() {
		if reg == nil {
			return
		}
		// gross hack, as there is no other way to cancel..
		// i tried sending myself sigterm, but that also stops ginkgo
		fieldValue := reflect.ValueOf(reg).Elem().FieldByName("server")
		ptr := fieldValue.Pointer()
		unsafe := unsafe.Pointer(ptr)
		srv := (*http.Server)(unsafe)
		srv.Shutdown(context.Background())
		<-wait
		reg = nil
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
		cmd := exec.Command("podman", "push", "localhost:5000/alpine", "--tls-verify=false")
		cmd.Stdout = GinkgoWriter
		cmd.Stderr = GinkgoWriter
		err := cmd.Run()
		Expect(err).NotTo(HaveOccurred())
		err = exec.Command("podman", "pull", "localhost:5000/alpine", "--tls-verify=false").Run()
		Expect(err).NotTo(HaveOccurred())
	})

	Context("publish survies restart", func() {
		FIt("should push and pull image", func() {
			cmd := exec.Command("podman", "push", "localhost:5000/alpine", "--tls-verify=false")
			cmd.Stdout = GinkgoWriter
			cmd.Stderr = GinkgoWriter
			err := cmd.Run()
			Expect(err).NotTo(HaveOccurred())

			// restart registry to make sure it persisted
			stopRegistry()
			runRegistry()
			cmd = exec.Command("podman", "pull", "localhost:5000/alpine", "--tls-verify=false")
			cmd.Stdout = GinkgoWriter
			cmd.Stderr = GinkgoWriter
			err = cmd.Run()
			Expect(err).NotTo(HaveOccurred())
		})
	})

})

type testDriverFactory struct {
	api     coreiface.CoreAPI
	ipnsKey string

	driver *ipfsdriver.IpfsDriver
}

func (s *testDriverFactory) Create(parameters map[string]interface{}) (storagedriver.StorageDriver, error) {
	var err error
	s.driver, err = ipfsdriver.NewDriverFromAPI(s.api, s.ipnsKey, false)
	return ipfsdriver.Wrap(s.driver), err
}

func defaultRepoWithKeyStore(dstore repo.Datastore) repo.Repo {
	// 512 for fast tests..
	ci.MinRsaKeyBits = 512
	priv, pub, err := ci.GenerateKeyPairWithReader(ci.RSA, ci.MinRsaKeyBits, rand.Reader)
	Expect(err).NotTo(HaveOccurred())

	pid, err := peer.IDFromPublicKey(pub)
	Expect(err).NotTo(HaveOccurred())

	privkeyb, err := ci.MarshalPrivateKey(priv)
	Expect(err).NotTo(HaveOccurred())

	c := config.Config{}
	// don't set bootstrap addresses. no need for test node to bootstrap...
	// 	c.Bootstrap = config.DefaultBootstrapAddresses
	c.Addresses.Swarm = []string{"/ip4/18.0.0.1/tcp/4001"}
	c.Identity.PeerID = pid.Pretty()
	c.Identity.PrivKey = base64.StdEncoding.EncodeToString(privkeyb)

	return &repo.Mock{
		D: dstore,
		C: c,
		K: keystore.NewMemKeystore(),
	}
}

// this is in a test, so cant re-use it

func MakeAPISwarm(ctx context.Context) ([]coreiface.CoreAPI, func(), error) {
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
		c.Addresses.Swarm = []string{fmt.Sprintf("/ip4/18.0.%d.1/tcp/4001", i)}
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
			Routing: libp2p.DHTServerOption,
			Repo:    r,
			Host:    mock.MockHostOption(mn),
			Online:  fullIdentity,
			ExtraOpts: map[string]bool{
				"pubsub": true,
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
