ARG ARCH=linux/amd64
FROM --platform=${ARCH} gcr.io/distroless/base-debian10
COPY oci-registry-p2p /oci-registry-p2p
ENTRYPOINT ["/oci-registry-p2p"]