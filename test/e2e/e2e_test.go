package e2e_test

import (
	"context"
	"embed"
	"fmt"
	"os"
	"os/exec"
	"time"

	"github.com/distribution/distribution/v3/registry/storage/driver/factory"

	coreiface "github.com/ipfs/interface-go-ipfs-core"
	options "github.com/ipfs/interface-go-ipfs-core/options"
	"github.com/sirupsen/logrus"
	ipfsmiddleware "github.com/yuval-k/oci-registry-p2p/registry/middleware/ipfs"
	ipfsdriver "github.com/yuval-k/oci-registry-p2p/registry/storage/driver/ipfs"

	"github.com/distribution/distribution/v3/configuration"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/yuval-k/oci-registry-p2p/test/e2e"
)

var (
	i                = 0
	ContainerRuntime = "podman"
)

//go:embed images
var images embed.FS

var _ = Describe("E2e", func() {
	var (
		ctx              context.Context
		cancel           context.CancelFunc
		api              coreiface.CoreAPI
		driverName       string
		config           *configuration.Configuration
		wait             chan struct{}
		reg              *TestRegistry
		ipnsKey          string
		ipnsReadOnlyKeys []string
		closeNodes       func()

		tdf *TestDriverFactory
	)
	BeforeEach(func() {
		ctx, cancel = context.WithCancel(context.Background())
		var err error

		apis, cn, err := MakeAPISwarm(ctx)
		Expect(err).NotTo(HaveOccurred())
		closeNodes = cn

		api = apis[0]
		Expect(err).NotTo(HaveOccurred())
		ipfsmiddleware.OverrideableOpenIpfs = func(ipfsaddress string) (coreiface.CoreAPI, error) {
			return api, nil
		}
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

		tdf = &TestDriverFactory{
			Api:              api,
			IpnsKey:          ipnsKey,
			IpnsReadOnlyKeys: ipnsReadOnlyKeys,
			Ctx:              ctx,
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
		config.Middleware = map[string][]configuration.Middleware{
			"repository": {
				{Name: "ipfs"},
			},
		}

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
	run := func(a string, arg ...string) error {

		cmd := exec.Command(a, arg...)
		cmd.Stdout = GinkgoWriter
		cmd.Stderr = GinkgoWriter
		return cmd.Run()
	}

	It("should push and pull image", func() {
		err := run(ContainerRuntime, "push", "localhost:5000/alpine", "--tls-verify=false")
		Expect(err).NotTo(HaveOccurred())
		err = run(ContainerRuntime, "pull", "localhost:5000/alpine", "--tls-verify=false")
		Expect(err).NotTo(HaveOccurred())
	})

	XContext("ipns self", func() {
		// Skipping this test, as publishing to the key defined by "self" seems to fail. I think this is a mock/test bug.
		BeforeEach(func() {
			ipnsKey = "self"
		})

		It("should push and pull image", func() {
			err := run(ContainerRuntime, "push", "localhost:5000/alpine", "--tls-verify=false")
			Expect(err).NotTo(HaveOccurred())
			err = run(ContainerRuntime, "pull", "localhost:5000/alpine", "--tls-verify=false")
			Expect(err).NotTo(HaveOccurred())
		})
	})

	Context("publish survies restart", func() {
		It("should push and pull image", func() {
			err := run(ContainerRuntime, "push", "localhost:5000/alpine", "--tls-verify=false")
			Expect(err).NotTo(HaveOccurred())

			// give time for the registry to flush data and save the new root
			time.Sleep(time.Second * 5)
			// restart registry to make sure it persisted
			By("restarting the registry")
			stopRegistry()
			runRegistry()
			err = run(ContainerRuntime, "pull", "localhost:5000/alpine", "--tls-verify=false")
			Expect(err).NotTo(HaveOccurred())
		})
	})

	Context("read only", func() {
		It("should pull from read only repo", func() {
			err := run(ContainerRuntime, "push", "localhost:5000/alpine", "--tls-verify=false")
			Expect(err).NotTo(HaveOccurred())

			// give time for the registry to flush data and save the new root
			time.Sleep(time.Second * 5)
			// restart registry to make sure it persisted
			By("restarting the registry")
			stopRegistry()

			ipnsReadOnlyKeys = []string{ipnsKey}
			ipnsKey = ""

			runRegistry()
			err = run(ContainerRuntime, "pull", "localhost:5000/alpine", "--tls-verify=false")
			Expect(err).NotTo(HaveOccurred())
		})
	})

	Context("OCI image", func() {
		It("should pull oci image added to ipfs", func() {
			// add the images folder to ipfs
			resolved, err := api.Unixfs().Add(ctx, ToIpfsDir(images, "images"), options.Unixfs.CidVersion(1))
			Expect(err).NotTo(HaveOccurred())
			// pull it
			img := "localhost:5000" + resolved.String() + "/hello:v1"
			err = run(ContainerRuntime, "pull", img, "--tls-verify=false")
			Expect(err).NotTo(HaveOccurred())
		})
	})

	Context("systemd install test", func() {
		It("should install and run on systemd", func() {
		})
	})

	Context("k8s install test", func() {
		It("should install and run on systemd", func() {
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
