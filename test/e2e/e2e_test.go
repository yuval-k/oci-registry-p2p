package e2e_test

import (
	"context"
	"embed"
	"fmt"
	"os"
	"os/exec"
	"runtime"
	"time"

	"github.com/distribution/distribution/v3/registry/storage/driver/factory"

	coreiface "github.com/ipfs/interface-go-ipfs-core"
	options "github.com/ipfs/interface-go-ipfs-core/options"
	"github.com/sirupsen/logrus"
	ipfsmiddleware "github.com/yuval-k/oci-registry-p2p/registry/middleware/ipfs"
	ipfsdriver "github.com/yuval-k/oci-registry-p2p/registry/storage/driver/ipfs"

	"github.com/distribution/distribution/v3/configuration"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	. "github.com/yuval-k/oci-registry-p2p/test/e2e"
)

var (
	i                 = 0
	ContainerRuntime  = "podman"
	AddTlsVerifyFalse = true
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
		reg              *TestRegistry
		ipnsKey          string
		ipnsReadOnlyKeys []string
		closeNodes       func()

		tdf *TestDriverFactory
	)
	BeforeEach(func() {
		logrus.SetOutput(GinkgoWriter)
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

		//api.Unixfs().Add()
		// initialize the registry
		// ipfsdriver.InitKey(ctx, api, ipnsKey)
	})

	runRegistry := func() {
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
		}()
	}
	stopRegistry := func() {
		if reg == nil {
			return
		}

		err := reg.Shutdown()
		Expect(err).NotTo(HaveOccurred())
		cancel()
		ctx, cancel = context.WithCancel(context.Background())
		fmt.Fprintln(GinkgoWriter, "waiting for registry to shutdown...")

		select {
		case <-reg.Done:
		case <-time.After(time.Second * 10):
			buf := make([]byte, 1<<20)
			stacklen := runtime.Stack(buf, true)
			fmt.Fprintf(GinkgoWriter, "registry did not shutdown in time goroutine dump...\n%s\n*** end\n", buf[:stacklen])
			Fail("registry did not shutdown in time")
		}

		time.Sleep(time.Second)
		fmt.Fprintln(GinkgoWriter, "registry shutdown")
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
		if AddTlsVerifyFalse {
			arg = append(arg, "--tls-verify=false")
		}

		cmd := exec.Command(a, arg...)
		cmd.Stdout = GinkgoWriter
		cmd.Stderr = GinkgoWriter
		return cmd.Run()
	}

	It("should push and pull image", func() {
		err := run(ContainerRuntime, "push", "localhost:5000/alpine")
		Expect(err).NotTo(HaveOccurred())
		err = run(ContainerRuntime, "pull", "localhost:5000/alpine")
		Expect(err).NotTo(HaveOccurred())
	})

	Context("ipns self", func() {
		// Skipping this test, as publishing to the key defined by "self" seems to fail. I think this is a mock/test bug.
		BeforeEach(func() {
			ipnsKey = "self"
			//	ipfsdriver.InitKey(ctx, api, ipnsKey)
		})

		It("should push and pull image", func() {
			err := run(ContainerRuntime, "push", "localhost:5000/alpine")
			Expect(err).NotTo(HaveOccurred())
			err = run(ContainerRuntime, "pull", "localhost:5000/alpine")
			Expect(err).NotTo(HaveOccurred())
		})
	})

	Context("publish survives restart", func() {
		It("should push and pull image", func() {
			err := run(ContainerRuntime, "push", "localhost:5000/alpine")
			Expect(err).NotTo(HaveOccurred())

			// give time for the registry to flush data and save the new root
			time.Sleep(time.Second * 5)
			// restart registry to make sure it persisted
			By("restarting the registry")
			stopRegistry()
			runRegistry()
			err = run(ContainerRuntime, "pull", "localhost:5000/alpine")
			Expect(err).NotTo(HaveOccurred())
		})
	})

	Context("read only", func() {
		It("should pull from read only repo", func() {
			err := run(ContainerRuntime, "push", "localhost:5000/alpine")
			Expect(err).NotTo(HaveOccurred())

			// give time for the registry to flush data and save the new root
			time.Sleep(time.Second * 5)
			// restart registry to make sure it persisted
			By("restarting the registry")
			stopRegistry()

			ipnsReadOnlyKeys = []string{ipnsKey}
			ipnsKey = ""

			runRegistry()
			err = run(ContainerRuntime, "pull", "localhost:5000/alpine")
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
			err = run(ContainerRuntime, "pull", img)
			Expect(err).NotTo(HaveOccurred())
		})
	})

	Context("systemd install test", func() {
		It("should install and run on systemd", func() {

			if ContainerRuntime != "podman" || os.Getenv("RUN_SYSTEMD_TEST") != "true" {
				Skip("only podman is supported for systemd install test")
			}

			// this test is way easier in the shell, so shell out
			cmd := exec.Command("./testsystemd.sh")
			cmd.Stdout = GinkgoWriter
			cmd.Stderr = GinkgoWriter
			err := cmd.Run()
			Expect(err).NotTo(HaveOccurred())
		})
	})

})

var _ = BeforeSuite(func() {

	useDocker := false
	// prefer podman, unless it is missing or docker explicitly requested.
	if os.Getenv("USE_DOCKER") == "1" {
		useDocker = true
	} else if _, err := exec.LookPath("podman"); err != nil {
		useDocker = true
	}
	if useDocker {
		ContainerRuntime = "docker"
		AddTlsVerifyFalse = false
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
