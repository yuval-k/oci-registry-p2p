package ipfs_test

import (
	"context"

	"github.com/distribution/distribution/v3/reference"
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	. "github.com/yuval-k/oci-registry-p2p/registry/middleware/ipfs"
)

var _ = Describe("Middleware", func() {
	It("should not intercept paths that are not ours", func() {

		ref, err := reference.WithName("test/foo")
		Expect(err).NotTo(HaveOccurred())
		path, err := ResolveRepo(nil, ref, Options{})
		Expect(err).NotTo(HaveOccurred())
		Expect(path).To(BeNil())

	})
	It("should intercept ipfs paths", func() {
		ref, err := reference.WithName("ipfs/bafybeie5nqv6kd3qnfjupgvz34woh3oksc3iau6abmyajn7qvtf6d2ho34")
		Expect(err).NotTo(HaveOccurred())
		path, err := ResolveRepo(nil, ref, Options{})
		Expect(err).NotTo(HaveOccurred())
		Expect(path).NotTo(BeNil())

	})
	It("should intercept ipns paths", func() {
		ref, err := reference.WithName("ipns/bafybeie5nqv6kd3qnfjupgvz34woh3oksc3iau6abmyajn7qvtf6d2ho34")
		Expect(err).NotTo(HaveOccurred())
		path, err := ResolveRepo(nil, ref, Options{})
		Expect(err).NotTo(HaveOccurred())
		Expect(path).NotTo(BeNil())

	})
	It("should intercept not ENS paths when ether node not configured", func() {
		ref, err := reference.WithName("test.eth")
		Expect(err).NotTo(HaveOccurred())
		path, err := ResolveRepo(nil, ref, Options{})
		Expect(err).NotTo(HaveOccurred())
		Expect(path).To(BeNil())
	})
	It("should intercept ENS paths", func() {
		ref, err := reference.WithName("test.eth")
		Expect(err).NotTo(HaveOccurred())
		_, err = ResolveRepo(context.Background(), ref, Options{EtherNodeUrl: "invalid url"})
		// we have an ether node and an ENS domain. The url is invalid, so we should get an error
		Expect(err).To(HaveOccurred())
	})
})
