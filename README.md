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

Install IPFS (note, this will install ipfs without persistance; it is only good for demo/test purposes):
```
kubectl create namespace registry
helm upgrade -i --namespace registry --version 0.4.2 registryipfs stable/ipfs --set swarm.enabled=true
```

enable the pubsub experiment:

```
kubectl patch statefulset -n registry registryipfs-ipfs  --type='strategic' -p '{"spec":{"template":{"spec":{"containers":[{"name":"ipfs","args":["daemon", "--migrate=true", "--enable-pubsub-experiment", "--enable-namesys-pubsub"]}]}}}}'

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
```
see full helm values: 

## Systemd (Raspberry PI, ubuntu, etc...)

TODO
make
cp binary /usr/local/bin/binary
cp install/svc.unit /etc.....
systemctl reload
systemctl enable start


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