What is this?

Docker registry backed by IPFS / OrbitDB

How to use this project??


TODOs:
- fill in this readme
- figure out CI
- add some content to ipfs registry on cluster
- update readme with ipfs content
- that's it :)

Demos:
  quick demo with "ipfs daemon --init --init-profile=test --debug" and ./registry -c config
  quick demo with docker compose
  quick demo with kubernetes
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

# Security
Running binary blobs from internet strangers is generally not a good idea.
Best practice is to use docker content addressing. i.e. instead of
```
docker pull ubuntu:focal
```
do:
```
docker pull ubuntu@sha256:7cc0576c7c0ec2384de5cbf245f41567e922aab1b075f3e8ad565f508032df17
```
Where the sha256 is retrieved from a trusted source. This guarantees that you get the current image.



# #########################################################3
TODO: include ipfs as subchart?
Our helm chart also includes IPFS with the proper settings


The core idea here is to re-use MFS, but instead of saving the root node in our ipfs node datastore,
we save and publish it to ipns. This way, buy knowing the ipns CID you can replicate the OCI registry.

You can use in 2 modes:
- write mode:
  - this is the default
  - there should only be 1 writer node for any ipns key
- read mode
  - read replicas for scale
  - read replicas for someone else's repo!
  - distributed docker registry!

# demo:
replicate my registery:

ipfs cat <...> | kubectl apply -f -
or
ipfs cat ... | docker load
dokcer run -p 5000 -ti docker.io/yuval-k/oci...:foo

docker run localhost/helloworld:5000

## Kubernetes

Install IPFS:
```
kubectl create namespace registry
helm upgrade -i --namespace registry --version 0.4.2 registryipfs stable/ipfs --set swarm.enabled=true --set persistence.enabled=true
```

enable the pubsub experiment:

```
kubectl patch statefulset -n registry registryipfs-ipfs --type='strategic' -p '{"spec":{"template":{"spec":{"containers":[{"name":"ipfs","args":["daemon", "--migrate=true", "--enable-pubsub-experiment", "--enable-namesys-pubsub"]}]}}}}'

kubectl -n registry rollout status statefulset/registryipfs-ipfs
```

create a db:
```
kubectl port-forward -n registry svc/registryipfs-ipfs 5001&
DB=$(go run scripts/createdb.go)
```

for local kind dev - build docker image
```
docker build -t oci-registry-p2p:dev .
```
load it into kind:
```
kind load docker-image oci-registry-p2p:dev
```
Or, load it into your node directly (this is for single node clusters):
```
docker save oci-registry-p2p:dev | ssh <your node> docker load
```

install registry:
```
helm --namespace registry upgrade -i registry ./install/helm/oci-registry-p2p --set orbitdb.orbitdbAddress=$DB --set orbitdb.ipfsPath=/dns4/registryipfs-ipfs.registry.svc.cluster.local/tcp/5001 --set image.repository=oci-registry-p2p --set image.tag=dev

kubectl -n registry rollout status deployment/registry-oci-registry-p2p
```
see more helm values in values.yaml.

port forward and push!

```
PORT=$(kubectl get service -n registry registry-oci-registry-p2p -o jsonpath='{.spec.ports[?(@.name=="http")].port}')
kubectl port-forward -n registry svc/registry-oci-registry-p2p 5000:$PORT &
podman pull alpine:3.10.1
podman tag alpine:3.10.1 localhost:5000/alpine
podman push localhost:5000/alpine --tls-verify=false
```

## Systemd (Raspberry PI, ubuntu, etc...)

TODO
make
cp binary /usr/local/bin/binary
cp install/svc.unit /etc.....
systemctl reload
systemctl enable start

# Persistency

This chart can be deployed in two ways. Deployment or StatefulSet.
When deployed as a stateful set, Orbitdb will flush it's state to a cache volume when a write occures. This allows restarting it.

When deploying as a deployment you can set `publishipns` to publish
the snapshot to the node's `ipns` key. you can customize the key name with `ipnskey` setting. This backup is less preferred as it doesn't save the replication queue, but allows for simpler deployment.

To create a custom `ipnskey`, run the following command:
```
ipfs key gen registry
```
View existing keys with
```
ipfs key list -l
```

# Configuring access

- get a cert from lets encrypt
  - option1: create wasm filter that answers http01. cert manager supports arm!
  - push docker zbam zbam zbam
  - create issuer, once the challenge is created, route to the challenge pod


TODO
## Security

Make sure to secure your configuration! running in container recommended!

## Firewall

TODO
## DNS

AWS


## TLS Certificate

Lets encrypt

TODO

# Using

Once installed, use just like a normal registry!

Get yourself certificates using Let's encrypt

push / pull!


# Replicating

Using IPFS allows you to use someone elses registry; simply follow the setup with someone elses db-id (orbitdbAddress).
read only of course. you can do this locally:
oci... -ipfsnode -db-id='...=


# new simpler design:
- no orbit db
- single master for writing
- multiple replicas for reading
- sync root hash to replicas
- master does auth like any other way
- master signs hash with some public key so slaves know it is legit
- ?!
- master needs to just serialize one thing, that root hash in ipns
- slaves follow the ipns name

- read root into memory
- manipulate memory
- flush new root


# How to proxy registry
This allows you to push/pull to your ipfs node and pull from a remote one at the same time