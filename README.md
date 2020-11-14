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
docker build -t docker-registry-p2p:dev .
kind load docker-image docker-registry-p2p:dev
```

install registry:
```
helm --namespace registry upgrade -i registry ./install/helm/docker-registry-p2p --set orbitdb.orbitdbAddress=$DB --set orbitdb.ipfsPath=/dns4/registryipfs-ipfs.registry.svc.cluster.local/tcp/5001 --set image.repository=docker-registry-p2p --set image.tag=dev

kubectl -n registry rollout status deployment/registry-docker-registry-p2p
```
see more helm values in values.yaml.

port forward and push!

```
PORT=$(kubectl get service -n registry registry-docker-registry-p2p -o jsonpath='{.spec.ports[?(@.name=="http")].port}')
kubectl port-forward -n registry svc/registry-docker-registry-p2p 5000:$PORT &
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

# Configuring access

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

TODO