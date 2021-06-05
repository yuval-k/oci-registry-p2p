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
	ipfsNodeAddress := "/ip4/127.0.0.1/tcp/5001"
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

	//fmt.Println("Our db ID:", db.Identity().ID)

	ac := &accesscontroller.CreateAccessControllerOptions{
		Access: map[string][]string{
			"admin": {db.Identity().ID},
			"write": {db.Identity().ID},
		},
	}

	createoptions := &orbitdb.CreateDBOptions{
		Create:           &t,
		StoreType:        &st,
		AccessController: ac,
	}
	kv, err := db.KeyValue(ctx, "oci-manifests", createoptions)
	if err != nil {
		panic(err)
	}
	fmt.Println(kv.Address())
}
