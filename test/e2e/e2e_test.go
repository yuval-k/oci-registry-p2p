package e2e_test

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"fmt"
	"os"
	"os/exec"
	"syscall"

	storagedriver "github.com/distribution/distribution/v3/registry/storage/driver"
	"github.com/distribution/distribution/v3/registry/storage/driver/factory"

	syncds "github.com/ipfs/go-datastore/sync"
	config "github.com/ipfs/go-ipfs-config"
	keystore "github.com/ipfs/go-ipfs-keystore"
	ipfscore "github.com/ipfs/go-ipfs/core"
	"github.com/ipfs/go-ipfs/core/coreapi"
	mock "github.com/ipfs/go-ipfs/core/mock"
	"github.com/ipfs/go-ipfs/core/node/libp2p"
	"github.com/ipfs/go-ipfs/repo"
	coreiface "github.com/ipfs/interface-go-ipfs-core"
	options "github.com/ipfs/interface-go-ipfs-core/options"
	ci "github.com/libp2p/go-libp2p-core/crypto"
	peer "github.com/libp2p/go-libp2p-core/peer"
	mocknet "github.com/libp2p/go-libp2p/p2p/net/mock"
	"github.com/sirupsen/logrus"
	ipfsdriver "github.com/yuval-k/oci-registry-p2p/registry/storage/driver/ipfs"

	"github.com/distribution/distribution/v3/configuration"
	"github.com/distribution/distribution/v3/registry"
	"github.com/ipfs/go-datastore"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var (
	i = 0
)

var _ = Describe("E2e", func() {
	var (
		ctx        context.Context
		cancel     context.CancelFunc
		node       *ipfscore.IpfsNode
		api        coreiface.CoreAPI
		driverName string
		config     *configuration.Configuration
		wait       chan struct{}
		reg        *registry.Registry

		tdf *testDriverFactory
	)
	BeforeEach(func() {
		i++
		driverName = fmt.Sprintf("%s%d", ipfsdriver.DriverName, i)
		ctx, cancel = context.WithCancel(context.Background())
		var err error
		mocknet := mocknet.New(ctx)

		d := syncds.MutexWrap(datastore.NewMapDatastore())

		node, err = ipfscore.NewNode(ctx, &ipfscore.BuildCfg{
			Routing: libp2p.DHTServerOption,
			Online:  true,
			Host:    mock.MockHostOption(mocknet),
			ExtraOpts: map[string]bool{
				"pubsub": true,
			},
			Repo: defaultRepoWithKeyStore(d),
		})
		Expect(err).NotTo(HaveOccurred())
		/*
			bsinf := bootstrap.BootstrapConfigWithPeers(
				[]peer.AddrInfo{
					node.Peerstore.PeerInfo(node.Identity),
				},
			)
			err = node.Bootstrap(bsinf)
		*/

		Expect(err).NotTo(HaveOccurred())
		api, err = coreapi.NewCoreAPI(node)
		Expect(err).NotTo(HaveOccurred())

		tdf = &testDriverFactory{
			api: api,
		}

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

		// signal ourselves with sig term to stop the distrbution
		// server
		syscall.Kill(syscall.Getpid(), syscall.SIGTERM)

		<-wait
		reg = nil
	}

	JustBeforeEach(runRegistry)

	AfterEach(func() {
		cancel()
		node.Close()
		stopRegistry()
	})

	FIt("should push and pull image", func() {
		cmd := exec.Command("podman", "push", "localhost:5000/alpine", "--tls-verify=false")
		cmd.Stdout = GinkgoWriter
		cmd.Stderr = GinkgoWriter
		err := cmd.Run()
		Expect(err).NotTo(HaveOccurred())
		err = exec.Command("podman", "pull", "localhost:5000/alpine", "--tls-verify=false").Run()
		Expect(err).NotTo(HaveOccurred())
	})

	Context("publish survies restart", func() {
		It("should push and pull image", func() {
			cmd := exec.Command("podman", "push", "localhost:5000/alpine", "--tls-verify=false")
			cmd.Stdout = GinkgoWriter
			cmd.Stderr = GinkgoWriter
			err := cmd.Run()
			Expect(err).NotTo(HaveOccurred())

			// restart registry to make sure it persisted
			stopRegistry()
			runRegistry()
			err = exec.Command("podman", "pull", "localhost:5000/alpine", "--tls-verify=false").Run()
			Expect(err).NotTo(HaveOccurred())
		})
	})

})

var _ = BeforeSuite(func() {
})

type testDriverFactory struct {
	api coreiface.CoreAPI

	driver *ipfsdriver.IpfsDriver
}

func (s *testDriverFactory) Create(parameters map[string]interface{}) (storagedriver.StorageDriver, error) {
	name := "testkey"

	key, err := s.api.Key().Generate(context.TODO(), name, options.Key.Type("rsa"), options.Key.Size(2048))
	if err != nil {
		return nil, err
	}
	ipnsKey := key.ID().Pretty()
	s.driver, err = ipfsdriver.NewDriverFromAPI(s.api, ipnsKey, false)
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
	c.Addresses.Swarm = []string{"/ip4/0.0.0.0/tcp/4001", "/ip4/0.0.0.0/udp/4001/quic"}
	c.Identity.PeerID = pid.Pretty()
	c.Identity.PrivKey = base64.StdEncoding.EncodeToString(privkeyb)

	return &repo.Mock{
		D: dstore,
		C: c,
		K: keystore.NewMemKeystore(),
	}
}
