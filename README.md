What is this?

Docker registry backed by IPFS / OrbitDB

How to use this project??

# Installation

## Pre-requisite

IPNS node. See installation instructions, here:

Our helm chart also includes IPNS with the proper settings

## Kubernetes

Easy as:
helm install ...

see full helm values: 

## Systemd (Raspberry PI, ubuntu, etc...)

make
cp binary /usr/local/bin/binary
cp install/svc.unit /etc.....
systemctl reload
systemctl enable start


# Configuring access

## Security

Make sure to secure your configuration! running in container recommended!

## Firewall

## DNS

AWS


## TLS Certificate

Lets encrypt


# Using

Once installed, use just like a normal registry!

Get yourself certificates using Let's encrypt

push / pull!
