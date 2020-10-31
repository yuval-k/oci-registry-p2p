package e2e_test

import (
	"context"
	"fmt"
	"os"
	"os/exec"

	orbitdb "berty.tech/go-orbit-db"
	"berty.tech/go-orbit-db/accesscontroller"
	storagedriver "github.com/docker/distribution/registry/storage/driver"
	"github.com/docker/distribution/registry/storage/driver/factory"
	ipfscore "github.com/ipfs/go-ipfs/core"
	"github.com/ipfs/go-ipfs/core/coreapi"
	mock "github.com/ipfs/go-ipfs/core/mock"
	coreiface "github.com/ipfs/interface-go-ipfs-core"
	mocknet "github.com/libp2p/go-libp2p/p2p/net/mock"
	"github.com/sirupsen/logrus"

	orbitdbdriver "github.com/yuval-k/docker-registry-p2p/registry/storage/driver/orbitdb"

	"github.com/docker/distribution/configuration"
	"github.com/docker/distribution/registry"

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
	)
	BeforeEach(func() {
		i++
		driverName = fmt.Sprintf("%s%d", orbitdbdriver.DriverName, i)
		ctx, cancel = context.WithCancel(context.Background())
		var err error
		mocknet := mocknet.New(ctx)
		node, err = ipfscore.NewNode(ctx, &ipfscore.BuildCfg{
			Online: true,
			Host:   mock.MockHostOption(mocknet),
			ExtraOpts: map[string]bool{
				"pubsub": true,
			},
		})
		Expect(err).NotTo(HaveOccurred())

		api, err = coreapi.NewCoreAPI(node)
		Expect(err).NotTo(HaveOccurred())

		ti := &testDriverFactory{
			api: api,
		}

		factory.Register(driverName, ti)

		fp, err := os.Open("config.yaml")
		Expect(err).NotTo(HaveOccurred())

		defer fp.Close()

		config, err := configuration.Parse(fp)
		Expect(err).NotTo(HaveOccurred())

		config.Storage[driverName] = config.Storage[orbitdbdriver.DriverName]
		delete(config.Storage, orbitdbdriver.DriverName)

		logrus.SetOutput(GinkgoWriter)

		registry, err := registry.NewRegistry(ctx, config)
		Expect(err).NotTo(HaveOccurred())

		go registry.ListenAndServe()
	})

	AfterEach(func() {
		cancel()
		node.Close()
	})

	It("should push and pull image", func() {
		err := exec.Command("podman", "push", "localhost:5000/alpine", "--tls-verify=false").Run()
		Expect(err).NotTo(HaveOccurred())
		err = exec.Command("podman", "pull", "localhost:5000/alpine", "--tls-verify=false").Run()
		Expect(err).NotTo(HaveOccurred())
	})

})

var _ = BeforeSuite(func() {
})

type testDriverFactory struct {
	api coreiface.CoreAPI
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
	return orbitdbdriver.NewDriverFromAPI(s.api, "", dbaddr)
}
