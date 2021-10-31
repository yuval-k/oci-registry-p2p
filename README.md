A IPFS backed storage implementation for docker/OCI registry. This Project brings together cloud-native and peer-to-peer by enabling you
# What is this?
to have p2p registries - an ability to fetch remote images without being directly connected to the remote registry the image was pushed to.
# What is this good for?

The core idea here is to re-use MFS, but instead of saving the root node in our ipfs node datastore (where it is only reachable to use),

We save and publish it to IPNS. This way, buy knowing the IPNS CID you can replicate the OCI registry. This enables the use case where I can push images to my registry, and other people can pull them, without making the registry itself publicly accessible. Additionally, if the original registry ever goes down, registries that
replicate off of it should not be effected, thus enabling distributed p2p OCI registries.

This is done by implementing the registry's storage driver. While the storage layout may not be guaranteed
to be the same over future versions of the registry, this is probably good enough™.

You can provide this repo and IPNS key from which it will read and write the MFS root (this is the root of the registry's storage).
In addition, you can provide a list of read only IPNS keys. If a path is not found in the write IPNS key, it will be searched in order in these keys. This allows mirroring of registries in remote nodes, while still being able
to use your node for writing.

Note that if you have multiple instances deployed using the same IPNS key, at most one should be enabled for writing. If there is more than one writer, the MFS root will become inconsistent.
# Prerequisites:

To run this project, all you need is an [IPFS](https://ipfs.io/) node (that you own).
To build it, you just need go (tested with go 1.16).
# Configuration

- ipfsapiaddress - Address of ipfs node api, in multi-address format. defaults to: "/ip4/127.0.0.1/tcp/5001"
- writeipnskey - IPNS key to publish the MFS root too. **Note**: Anyone who knows this value will have read only access to this registry.
- readonlyipnskeys - A string list or a command separated string of IPNS keys to read paths from if not found in the writeipnskey. This is useful if you don't own the IPNS key or want to have more than one instance running. (optional, defaults false)

Note that if both writeipnskey and readonlyipnskeys are empty, an error starting the registry will occur. 

# Quick 30 second demo.
This assumes you already have an IPNS node on localhost (adjust config with node address otherwise).

To give this project a quick test, run it in one terminal:
```
# Note these certs are for testing, and should NOT be used for any real purpose.
# These certs are public an not secure.
cp test/e2e/cert.pem .
cp test/e2e/key.pem .
go run . serve example-config.yaml
```

And in another terminal, push images to `localhost:5000`:
```
docker pull docker.io/library/alpine:3.10.1
docker tag docker.io/library/alpine:3.10.1 localhost:5000/alpine
docker push localhost:5000/alpine --tls-verify=false
```

The example config has a remote registry preconfigured. To pull an image from a remote registry, just do:
```
docker pull localhost:5000/hello@sha<TODO>
```

Note: that registry configuration parameters can be also be changed via environment variables. For example:

```
export REGISTRY_STORAGE_IPFS_IPFSAPIADDRESS=/ip4/...
// run registry
```

See more info [here](https://docs.docker.com/registry/configuration/).

Note: Pushing It may take a minute, as publishing to IPNS takes time. In the future we can trade off so of that time with less consistency. Pulling should be fast.

# Installation

## Systemd

## Docker/Podman

## Kubernetes

Install IPFS:

Install this project:

# Security

Running binary blobs from internet strangers is generally not a good idea.
Best practice is to use docker content addressing. i.e. instead of

```
docker pull ubuntu:focal
```

Do:

```
docker pull ubuntu@sha256:7cc0576c7c0ec2384de5cbf245f41567e922aab1b075f3e8ad565f508032df17
```

Where the sha256 is retrieved from a trusted source. This guarantees that you get the current image.

# Use Cases

## Regular registry backed by IPFS
While not suited to large enterprises with large amount of writes, may be suitable to a smaller environment
that already has an IPFS node, Re-using the IPFS node to hold state.
## Read-only from remote registry
You can check out my registry, at the IPNS address: `k51qzi5uqu5dlj2qkibv67ep4sdsa73s9asv2g3um5j441i80ks15e1afi7waz`
## Read-and-write

Combination of above cases, where you can push to your own registry, while also using images from other registries.

# FAQ

## I see `failed to find any peer in table` in the logs.
It seems that your node needs to be connected to more nodes to publish IPNS.
