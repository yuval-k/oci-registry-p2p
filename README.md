A IPFS backed storage implementation for docker/OCI registry. This Project brings together cloud-native and peer-to-peer by enabling you
# What is this?
to have p2p registries - an ability to fetch remote images without being directly connected to the remote registry the image was pushed to.
# What is this good for?

P2P OCI registries give you the ability to pull container images from IPFS, without being directly connected
to a different registry.

# Prerequisites:

To run this project, all you need is an [IPFS](https://ipfs.io/) node (that you own).
To build it, you just need go (tested with go 1.16).

# Quick 10 second demo (storage driver mode).
```
# In the first terminal run ipfs if not running
ipfs daemon --init

# In a second terminal, run the following:
cp test/e2e/cert.pem .
cp test/e2e/key.pem .
go run . serve scripts/example-config.yaml

# Wait until the registry initializes (may take a minute), and then run the following in a third terminal:
docker run --rm localhost:5000/hello@sha256:d6f8f32bc1fc6cd09ecc4634551219d7e941065a1ecc5363b6c1f84d85bc00ad --tls-verify=false
```

# Quick 30 second demo - pushing to MFS/IPNS (storage driver mode).
This assumes you already have an IPNS node on localhost (adjust config with node address otherwise).

To give this project a quick test, run it in one terminal:
```
# Note these certs are for testing, and should NOT be used for any real purpose.
# These certs are public an not secure.
cp test/e2e/cert.pem .
cp test/e2e/key.pem .
go run . serve scripts/example-config.yaml
```

And in another terminal, push images to `localhost:5000`:
```
docker pull docker.io/library/alpine:3.10.1
docker tag docker.io/library/alpine:3.10.1 localhost:5000/alpine
docker push localhost:5000/alpine --tls-verify=false
```

The example config has a remote registry preconfigured. To pull an image from a remote registry, just do:
```
docker pull localhost:5000/hello@sha256:d6f8f32bc1fc6cd09ecc4634551219d7e941065a1ecc5363b6c1f84d85bc00ad
```

Note: that registry configuration parameters can be also be changed via environment variables. For example:

```
export REGISTRY_STORAGE_IPFS_IPFSAPIADDRESS=/ip4/...
// run registry
```

See more info [here](https://docs.docker.com/registry/configuration/).

Note: Pushing It may take a minute, as publishing to IPNS takes time. In the future we can trade off so of that time with less consistency. Pulling should be fast.
# Quick 20 second demo - Pulling OCI Image directly from IPFS (middleware mode).
With this mode, there is *no need* for any IPNS configuration for the registry.
What we do instead, is place the container directly on an IPFS node in the OCI image format,
and use the repository to pull it.

This mode uses a registry middleware instead of a storage driver, and is more likely to be future proof.
Currently, pushing through the repository is not supported. See the next demo below that uses `podman`
to pull a container from docker hub and "push" it to IPFS.


```bash
# In the first terminal run ipfs if not running
ipfs daemon --init

# In a second terminal, Start the registry. run the following:
cp test/e2e/cert.pem .
cp test/e2e/key.pem .
go run . serve scripts/example-config.yaml

# In a third terminal:
# This is the CID of an images folder i pushed
CID=bafybeielgvrvxuraaa6s36ww575ogm2jc6haclf7sghyf7d3rtiodisbrq
# Now you can use docker/podman to pull or run the image just added to IPFS!
# note that you can also use /ipns names
# Try the following commands:
podman pull localhost:5000/ipfs/${CID}/alpine:3.10.1 --tls-verify=false
podman run -ti --rm --tls-verify=false localhost:5000/ipfs/${CID}/alpine:3.10.1 /bin/sh
```

Note: A nice property of IPFS is that it will automatically de-duplicate the various layers.
This means that if you push the same layer from multiple images, the layer will not use twice the storage.
# Quick 30 second demo - Pulling OCI Image directly from IPFS (middleware mode).
Following up from the demo above, we'll show how to get an OCI image to IPFS.
As currently, pushing through the repository is not supported. With this example we will use  `podman` to pull a container from docker hub and "push" it to an OCI folder. We will then
add that folder to IPFS.

```bash
# In the first terminal run ipfs if not running
ipfs daemon --init

# In a second terminal, Start the registry. run the following:
cp test/e2e/cert.pem .
cp test/e2e/key.pem .
go run . serve scripts/example-config.yaml

# In a third terminal:

# Pull and image from docker hub
podman pull docker.io/library/alpine:3.10.1
# Create the folder where the images will be
mkdir images
# "Push" the image to the OCI folder. note the "oci:" prefix.
# this will result with a directory named images/alpine created with the OCI image format layout
podman push docker.io/library/alpine:3.10.1 oci:./images/alpine:3.10.1
# Add the images folder to IPFS, and store the final CID to an environment variable. 
# It is important to use CID version 1, as it is case-insensitive (container images need to be lower case).
CID=$(ipfs add -Q -r --cid-version 1 ./images)

# Now you can use docker/podman to pull or run the image just added to IPFS!
# note that you can also use /ipns names
# Try the following commands:
podman pull localhost:5000/ipfs/${CID}/alpine:3.10.1 --tls-verify=false
podman run -ti --rm --tls-verify=false localhost:5000/ipfs/${CID}/alpine:3.10.1 /bin/sh
```

Note: A nice property of IPFS is that it will automatically de-duplicate the various layers.
This means that if you push the same layer from multiple images, the layer will not use twice the storage.
# Configuration

- `ipfsapiaddress` - Address of ipfs node api, in multi-address format. defaults to: "/ip4/127.0.0.1/tcp/5001"
- `writeipnskey` - IPNS key to publish the MFS root too. **Note**: Anyone who knows this value will have read only access to this registry.
- `readonlyipnskeys` - A string list or a command separated string of IPNS keys to read paths from if not found in the `writeipnskey`. This is useful if you don't own the IPNS key or want to have more than one instance running. (optional, defaults false)

Note: For the storage driver, if both `writeipnskey` and `readonlyipnskeys` are empty, an error starting the registry will occur. If you just want to use the registry middleware, you can use the
 `inmemory` storage driver.

Note: The registry middleware configuration only accepts the `ipfsapiaddress` parameter
# Technical notes
This registry adds to components that interact with IPFS. They are independent and you can use either of them or both of them:
- Storage driver approach
- Registry middleware approach
## Storage Driver
This component allows you to use IPFS as a storage driver, abstracting IPFS form your users.
To use this mode, you need to pre-configure IPNS addresses that will be used as the "root" folder
of the storage driver. This mode allows you to push and pull images.

The core idea here is to re-use MFS, but instead of saving the root node in our IPFS node datastore (where it is only reachable to you, the node owner), we save and publish it to IPNS.
This way, buy knowing the IPNS CID you can replicate the OCI registry. This enables the use case where I can push images to my registry, and other people can pull them, without making the registry itself publicly accessible. Additionally, if the original registry ever goes down, registries that
replicate off of it should not be effected, thus enabling distributed p2p OCI registries.

This is done by implementing the registry's storage driver. While the storage layout may not be guaranteed
to be the same over future versions of the registry, this is probably good enough™.

You can provide this repo and IPNS key from which it will read and write the MFS root (this is the root of the registry's storage).
In addition, you can provide a list of read only IPNS keys. If a path is not found in the write IPNS key, it will be searched in order in these keys. This allows mirroring of registries in remote nodes, while still being able
to use your node for writing.

Note that if you have multiple instances deployed using the same IPNS key, at most one should be enabled for writing. If there is more than one writer, the MFS root will become inconsistent.
## Registry Middleware
The registry middleware component allows you to pull (but not push) images from any IPFS or IPNS address without pre-configuration (beyond the IPFS node). In this mode, IPFS is not abstracted from the user - The registry name represents an IPFS path that contains a folder layed-out as an [OCI image](https://github.com/opencontainers/image-spec/blob/main/image-layout.md).

The advantage of this mode that no additional address configuration is needed. In addition, as this is based on the OCI Image spec, it is more likely to be future compatible.

See more details in [docs/middleware.md](docs/middleware.md).
# Installation
TODO
## Systemd
TODO

## Docker/Podman
TODO

## Kubernetes

Install IPFS in your k8s environment. Then, Install this project:
```shell
IPFS_ADDR=/dns4/<NAME.NAMESPACE of IPFS service>/tcp/5001
REGISTRY_HOSTNAME=example.com # change this to the hostname as observed by clients

# create a registry key
ipfs --api=$IPFS_ADDR key gen registry

kubectl create ns registry
helm --namespace registry upgrade -i registry ./install/helm/oci-registry-p2p --set ipfs.publishIpnsKey=registry --set ipfs.address=$IPFS_ADDR --set image.repository=ghcr.io/yuval-k/oci-p2p-registry --set image.tag=0.2.0 --set registry.http.host=$REGISTRY_HOSTNAME
```
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

Where the sha256 is retrieved from a trusted source. This guarantees that you get the correct image, regardless of who gives it to you.

# Use Cases

## Regular registry backed by IPFS
While not suited to large enterprises with large amount of writes, may be suitable to a smaller environment
that already has an IPFS node, Re-using the IPFS node to hold state.
## Read-only from remote registry
You can check out my registry, at the IPNS address: `k51qzi5uqu5dlj2qkibv67ep4sdsa73s9asv2g3um5j441i80ks15e1afi7waz`
## Read-and-write

Combination of above cases, where you can push to your own registry, while also using images from other registries.

# FAQ

- I see `failed to find any peer in table` in the logs.
  It seems that your node needs to be connected to more nodes to publish IPNS.

- Why have 2 independent components (storage driver and middleware)?
  The test the two approaches as I'm not sure which will be more ergonomic longer term. The real 
  answer might be a combination of the two - a middleware mode that allows pushing an image as well.
