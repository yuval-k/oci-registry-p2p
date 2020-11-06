What is this?

Docker registry backed by IPFS / OrbitDB

How to use this project??

# Installation

TODO

## Pre-requisite

IPFS node. See installation instructions, here:

TODO: include ipfs as subchart?
Our helm chart also includes IPFS with the proper settings

## Kubernetes

TODO:
```
kubectl create namespace registry
helm upgrade -i registry ./install/helm/docker-registry-p2p
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