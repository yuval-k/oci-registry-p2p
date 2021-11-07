
The registry middleware can help you access your containers in an IPFS address, without any pre-configuration
(aside from your IPFS node.)


# Configuration of the middleware
Simple add this snippet to the registry configuration file 

```
middleware:
  repository:
    - name: ipfs
      options:
        ipfsapiaddress: /ip4/127.0.0.1/tcp/5001
```

Where ipfsapiaddress points to the the address and api port of your IPFS node.

# Getting container images to IPFS:

Docker it seems has limited OCI support; but Red-hat has a bunch of tools that support the OCI image spec. You can use [skopeo](https://github.com/containers/skopeo/blob/main/install.md) to directly copy an image from docker hub to an oci folder:

```
skopeo copy docker://docker.io/library/alpine:3.10.1 oci:./images/alpine:3.10.1
```

And you can use it to copy docker archives:
```
docker pull alpine:3.10.1
docker save alpine:3.10.1 > tmp.tar
skopeo copy docker-archive:a.tar oci:./images/alpine:3.10.1
rm tmp.tar
```

[Podman](https://github.com/containers/podman/blob/main/install.md) (available only in linux), can build and "push" an image to store it in an OCI folder:

```
podman push docker.io/library/alpine:3.10.1 oci:./images/alpine:3.10.1
```

After running either command, you can add the `images` folder to IPFS using the `ipfs add` command:
```
ipfs add -r --cid-version 1 ./images
```

You will see an output similar to this:
```
added bafybeibtthygdq32333y2w5to75jooklvoxgmbzffecraa6yrcum6i35gy images/alpine/blobs/sha256/0503825856099e6adb39c8297af09547f69684b7016b7f3680ed801aa310baaa
added bafkreib37hpff44kukd3k6j32kv4vg6kmlvqs6wqnptgbp6xret4cokwke images/alpine/blobs/sha256/3bf9de52f38aa287b5793bd2abca9bca62eb097ad06be660bfd78927c1395651
added bafkreicpufj2qjbgvuyi42o54u6xpk5rxp5z2bu33665pw2q6yk33ewxvy images/alpine/blobs/sha256/4fa153a82426ad308e69dde53d77abb1bbfb9d069bdfbdd7db50f615bd92d7ae
added bafkreiawhhj4z4izqgmv4ne5bvj4u5thvltialon6ocbklpted2vodetp4 images/alpine/index.json
added bafkreiam33oaq2owbo2z4po6onxzsybf44brqgafq7qett5cf6anm6vi4u images/alpine/oci-layout
added bafybeiduw3e2ftz5zecyaklql4szy6pficihxj3jrde4pzhhqomcbifbhu images/alpine/blobs/sha256
added bafybeicltekbqmuqlecd2wq3fki37xisi5ni4aarjlqepav5qbr2g5riim images/alpine/blobs
added bafybeibez5fjqomhjj6fmde2w34rmz34ypl2zaqiktilmw26qichpvuiey images/alpine
added bafybeigisrxnnkk226dkwaj5piaxcrit47t3egwapbca2cbiojvss3of4u images
 2.66 MiB / 2.66 MiB [=========================================] 100.00%
```

The last hash in this list, the one for `images` is the one we need to use. Assuming our registry
is running in `localhost:5000`, we can just do:

# Running it
```
docker run -ti --rm localhost:5000/ipfs/bafybeigisrxnnkk226dkwaj5piaxcrit47t3egwapbca2cbiojvss3of4u/alpine:3.10.1 /bin/sh
```
In fact, assuming you configured the middleware, you can already run this step without running the steps above,
as I had already run it in my IPFS instance. It is enough that a single person world wide will add an image to make it accessible to the whole world.