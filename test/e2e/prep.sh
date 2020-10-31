#/bin/sh

podman pull alpine:3.10.1
podman tag alpine:3.10.1 localhost:5000/alpine
