package main

import (
	_ "net/http/pprof"

	"github.com/distribution/distribution/v3/registry"
	distversion "github.com/distribution/distribution/v3/version"

	_ "github.com/distribution/distribution/v3/registry/auth/htpasswd"
	_ "github.com/distribution/distribution/v3/registry/auth/silly"
	_ "github.com/distribution/distribution/v3/registry/auth/token"
	_ "github.com/distribution/distribution/v3/registry/proxy"
	_ "github.com/distribution/distribution/v3/registry/storage/driver/filesystem"
	_ "github.com/distribution/distribution/v3/registry/storage/driver/inmemory"
	_ "github.com/distribution/distribution/v3/registry/storage/driver/middleware/redirect"

	_ "github.com/yuval-k/oci-registry-p2p/registry/middleware"
	_ "github.com/yuval-k/oci-registry-p2p/registry/storage/driver/ipfs"
	ourversion "github.com/yuval-k/oci-registry-p2p/version"
)

var (
	version = "dev"
	commit  = "none"
	date    = "unknown"
	builtBy = "unknown"
)

func main() {
	distversion.Version = ourversion.Version
	if ourversion.VersionPrerelease != "" {
		distversion.Version += "-" + ourversion.VersionPrerelease
	}
	distversion.Revision = ourversion.Commit
	distversion.Package = "github.com/yuval-k/oci-registry-p2p"

	registry.RootCmd.Execute()
}
