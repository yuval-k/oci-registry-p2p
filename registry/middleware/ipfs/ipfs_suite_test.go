package ipfs_test

import (
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

func TestIpfs(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Ipfs Suite")
}
