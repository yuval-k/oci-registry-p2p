ARG ARCH=linux/amd64
# FROM --platform=${ARCH} gcr.io/distroless/static-debian10
FROM --platform=${ARCH} docker.io/library/alpine:3.14.2
LABEL org.opencontainers.image.source https://github.com/yuval-k/oci-registry-p2p/
COPY oci-registry-p2p /oci-registry-p2p
ENTRYPOINT ["/oci-registry-p2p"]