# Get the bits
This release can also be found on IPFS. See it here:

```shell
ipfs ls /ipfs/@CID@
```

# Docker image
It is also available in the `ghcr.io` container registry. Try:

```shell
docker pull ghcr.io/yuval-k/oci-p2p-registry:@TAG@
```

# Install in kubernetes

## One time setup

```shell
# create the registry key in your K8S node:
kubectl exec -n ipfs deploy/ipfs -- ipfs key gen registry

# create registry namespace
kubectl create ns registry
```

## Install the release

```shell
IPFS_ADDR=/dns4/<NAME.NAMESPACE of IPFS service>/tcp/5001
REGISTRY_HOSTNAME=example.com # change this to the hostname as observed by clients

ipfs get /ipfs/@CID@/helm/oci-registry-p2p-@TAG@.tgz
helm --namespace registry upgrade -i registry oci-registry-p2p.tgz --set ipfs.publishIpnsKey=registry --set ipfs.address=$IPFS_ADDR --set image.repository=ghcr.io/yuval-k/oci-p2p-registry --set registry.http.host=$REGISTRY_HOSTNAME
```