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
# adjust namespace kind/name accordingly
kubectl exec -n ipfs deploy/ipfs -- ipfs key gen registry

# create registry namespace
kubectl create ns registry
```

## Helm - Install/Upgrade the release

```shell
IPFS_ADDR=/dns4/<NAME.NAMESPACE of IPFS service>/tcp/5001
REGISTRY_HOSTNAME=example.com # change this to the hostname as observed by clients

ipfs get /ipfs/@CID@/helm/oci-registry-p2p-@TAG@.tgz
helm --namespace registry upgrade -i registry oci-registry-p2p.tgz --set ipfs.publishIpnsKey=registry --set ipfs.address=$IPFS_ADDR --set image.repository=ghcr.io/yuval-k/oci-p2p-registry --set registry.http.host=$REGISTRY_HOSTNAME
```
## Plain Kubernetes

We also provide a plain kubernetes manifest. But for it to work you need to:
- Adjust the config map with the correct address to your IPFS node
- Create a tls secret named "release-oci-registry-p2p" with the certificates to use.

For testing purposes, you can create a tls secret like so:
```
openssl req -new -newkey rsa:2048 -x509 -sha256 \
        -days 3650 -nodes -out tls.crt -keyout tls.key \
        -subj "/CN=ipfs-test-ca.example.com" \
        -addext "extendedKeyUsage = clientAuth, serverAuth"
kubectl create secret tls release-oci-registry-p2p --key="tls.key" --cert="tls.crt"
```

You can then apply the manifest yaml:
```
kubectl apply -f dist/k8s/manifest.yaml
```