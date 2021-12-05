package ipfs

import (
	"github.com/ethereum/go-ethereum/ethclient"
	ipfspath "github.com/ipfs/interface-go-ipfs-core/path"
	ens "github.com/wealdtech/go-ens/v3"
)

func resolveEns(client *ethclient.Client, name string) (ipfspath.Path, error) {
	resolver, err := ens.NewResolver(client, name)
	if err != nil {
		return nil, err
	}
	bin, err := resolver.Contenthash()
	if err != nil {
		return nil, err
	}
	repr, err := ens.ContenthashToString(bin)
	location := ipfspath.New(repr)
	return location, location.IsValid()
}
