What is this?

Docker registry backed by IPFS / OrbitDB

How to use this project??

# Installation

TODO

## Pre-requisite

IPFS node. See installation instructions, here:

TODO: include ipfs as subchart?
Our helm chart also includes IPFS with the proper settings

create db
create ipns key
configure



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
