package e2e_test

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"reflect"
	"unsafe"

	orbitdb "berty.tech/go-orbit-db"
	"berty.tech/go-orbit-db/accesscontroller"
	storagedriver "github.com/distribution/distribution/v3/registry/storage/driver"
	"github.com/distribution/distribution/v3/registry/storage/driver/factory"
	dsync "github.com/ipfs/go-datastore/sync"
	cfg "github.com/ipfs/go-ipfs-config"
	ipfscore "github.com/ipfs/go-ipfs/core"
	"github.com/ipfs/go-ipfs/core/coreapi"
	mock "github.com/ipfs/go-ipfs/core/mock"
	"github.com/ipfs/go-ipfs/keystore"
	"github.com/ipfs/go-ipfs/repo"
	coreiface "github.com/ipfs/interface-go-ipfs-core"
	ci "github.com/libp2p/go-libp2p-core/crypto"
	peer "github.com/libp2p/go-libp2p-peer"
	mocknet "github.com/libp2p/go-libp2p/p2p/net/mock"
	"github.com/sirupsen/logrus"

	orbitdbdriver "github.com/yuval-k/oci-registry-p2p/registry/storage/driver/orbitdb"

	"github.com/distribution/distribution/v3/configuration"
	"github.com/distribution/distribution/v3/registry"
	ds "github.com/ipfs/go-datastore"

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
		driverName = fmt.Sprintf("%s%d", orbitdbdriver.DriverName, i)
		ctx, cancel = context.WithCancel(context.Background())
		var err error
		mocknet := mocknet.New(ctx)
		var d repo.Datastore
		d = ds.NewMapDatastore()
		d = dsync.MutexWrap(d)

		node, err = ipfscore.NewNode(ctx, &ipfscore.BuildCfg{
			Online: true,
			Host:   mock.MockHostOption(mocknet),
			ExtraOpts: map[string]bool{
				"pubsub": true,
			},
			Repo: defaultRepoWithKeyStore(d),
		})
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

		config.Storage[driverName] = config.Storage[orbitdbdriver.DriverName]
		delete(config.Storage, orbitdbdriver.DriverName)

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
		node.Close()
		stopRegistry()
	})

	It("should push and pull image", func() {
		err := exec.Command("podman", "push", "localhost:5000/alpine", "--tls-verify=false").Run()
		Expect(err).NotTo(HaveOccurred())
		err = exec.Command("podman", "pull", "localhost:5000/alpine", "--tls-verify=false").Run()
		Expect(err).NotTo(HaveOccurred())
	})

	Context("publish ipns", func() {
		BeforeEach(func() {
			tdf.publishInfs = true
		})
		It("should push and pull image", func() {
			err := exec.Command("podman", "push", "localhost:5000/alpine", "--tls-verify=false").Run()
			Expect(err).NotTo(HaveOccurred())

			// flush; this should happen automatically in the background, but we do it manually to reduce flakes.
			// not the best solution as it doesn't test how it runs in real usage, but better dev flow.
			tdf.driver.Flush(ctx)

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
	api         coreiface.CoreAPI
	cacheDir    string
	publishInfs bool
	ipnsKey     string

	driver *orbitdbdriver.IpfsDriver
}

func (s *testDriverFactory) Create(parameters map[string]interface{}) (storagedriver.StorageDriver, error) {

	options := &orbitdb.NewOrbitDBOptions{}
	ctx := context.TODO()
	db, err := orbitdb.NewOrbitDB(ctx, s.api, options)
	Expect(err).NotTo(HaveOccurred())
	t := true
	st := "keyvalue"

	ac := &accesscontroller.CreateAccessControllerOptions{
		Access: map[string][]string{
			"admin": {"*"},
			"write": {"*"},
		},
	}

	createoptions := &orbitdb.CreateDBOptions{
		Create:           &t,
		StoreType:        &st,
		AccessController: ac,
	}
	kv, err := db.KeyValue(ctx, "test", createoptions)
	Expect(err).NotTo(HaveOccurred())
	dbaddr := kv.Address().String()
	s.driver, err = orbitdbdriver.NewDriverFromAPI(s.api, s.cacheDir, dbaddr, s.publishInfs, s.ipnsKey)
	return orbitdbdriver.Wrap(s.driver), err
}

func defaultRepoWithKeyStore(dstore repo.Datastore) repo.Repo {
	c := cfg.Config{}
	// 512 for fast tests..
	ci.MinRsaKeyBits = 512
	priv, pub, err := ci.GenerateKeyPairWithReader(ci.RSA, ci.MinRsaKeyBits, rand.Reader)
	Expect(err).NotTo(HaveOccurred())

	pid, err := peer.IDFromPublicKey(pub)
	Expect(err).NotTo(HaveOccurred())

	privkeyb, err := priv.Bytes()
	Expect(err).NotTo(HaveOccurred())

	c.Bootstrap = cfg.DefaultBootstrapAddresses
	c.Addresses.Swarm = []string{"/ip4/0.0.0.0/tcp/4001", "/ip4/0.0.0.0/udp/4001/quic"}
	c.Identity.PeerID = pid.Pretty()
	c.Identity.PrivKey = base64.StdEncoding.EncodeToString(privkeyb)

	ks := keystore.NewMemKeystore()
	return &repo.Mock{
		D: dstore,
		C: c,
		K: ks,
	}
}
