package main

import (
	"context"
	"fmt"
	"os"

	orbitdb "berty.tech/go-orbit-db"
	"berty.tech/go-orbit-db/accesscontroller"
	httpapi "github.com/ipfs/go-ipfs-http-client"
	ma "github.com/multiformats/go-multiaddr"
)

func main() {
	ipfsNodeAddress := "/ip4/192.168.1.3/tcp/31341"
	if len(os.Args) > 2 {
		ipfsNodeAddress = os.Args[1]
	}

	addr, err := ma.NewMultiaddr(ipfsNodeAddress)
	if err != nil {
		panic(err)
	}
	api, err := httpapi.NewApi(addr)
	if err != nil {
		panic(err)
	}

	options := &orbitdb.NewOrbitDBOptions{}
	ctx := context.TODO()
	db, err := orbitdb.NewOrbitDB(ctx, api, options)
	if err != nil {
		panic(err)
	}
	// TODO: document that we need to make sure only one writer.
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
	if err != nil {
		panic(err)
	}
	fmt.Println(kv.Address())
}
