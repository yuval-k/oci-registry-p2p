REPO=oci-p2p-registry
REGISTRY=docker.io/uvgroovy
PUSH_FLAGS=

# REGISTRY=localhost:5000/uvgroovy
# PUSH_FLAGS=--tls-verify=false

CONTAINER_RUNTIME=podman

GH_REPO=github.com/yuval-k/oci-registry-p2p
COMMIT=$(shell git rev-parse HEAD)
VERSION=$(shell git describe --tags --always --dirty)
PROJECT_NAME=oci-registry-p2p
TAG=$(VERSION:v%=%)
IMAGE_NAME=$(REGISTRY)/$(REPO):$(TAG)

add-img-arm64:
	GOOS=linux GOARCH=arm64 go build -o oci-registry-p2p .
	$(CONTAINER_RUNTIME) build -f Dockerfile --os linux --arch arm64 --variant v8 -t $(IMAGE_NAME)-arm64 --build-arg=ARCH=linux/arm64 .
	$(CONTAINER_RUNTIME) push $(IMAGE_NAME)-arm64 $(PUSH_FLAGS)
	$(CONTAINER_RUNTIME) manifest add $(IMAGE_NAME) $(IMAGE_NAME)-arm64 --os linux --arch arm64 --variant v8 $(PUSH_FLAGS)

add-img-arm7:
	GOOS=linux GOARCH=arm GOARM=7 go build -o oci-registry-p2p .
	$(CONTAINER_RUNTIME) build -f Dockerfile --os linux --arch arm --variant v7 -t $(IMAGE_NAME)-armv7 --build-arg=ARCH=linux/arm/v7 .
	$(CONTAINER_RUNTIME) push $(IMAGE_NAME)-armv7 $(PUSH_FLAGS)
	$(CONTAINER_RUNTIME) manifest add $(IMAGE_NAME) $(IMAGE_NAME)-armv7 --os linux --arch arm --variant v7 $(PUSH_FLAGS)

add-img-amd64:
	GOOS=linux GOARCH=amd64 go build -o oci-registry-p2p .
	$(CONTAINER_RUNTIME) build -f Dockerfile --os linux --arch amd64 -t $(IMAGE_NAME)-amd64 --build-arg=ARCH=linux/amd64 .
	$(CONTAINER_RUNTIME) push $(IMAGE_NAME)-amd64 $(PUSH_FLAGS)
	$(CONTAINER_RUNTIME) manifest add $(IMAGE_NAME) $(IMAGE_NAME)-amd64 --os linux --arch amd64 $(PUSH_FLAGS)

manifest-create:
	$(CONTAINER_RUNTIME) manifest create $(IMAGE_NAME)

manifest-cleanup:
	$(CONTAINER_RUNTIME) manifest rm $(IMAGE_NAME)

image:
	$(MAKE) manifest-create
	$(MAKE) add-img-arm7
	$(MAKE) add-img-arm64
	$(MAKE) add-img-amd64
	$(CONTAINER_RUNTIME) manifest push $(IMAGE_NAME) docker://$(IMAGE_NAME) $(PUSH_FLAGS)

publish-ipfs:
	$(CONTAINER_RUNTIME) pull $(IMAGE_NAME) $(PUSH_FLAGS)
	$(CONTAINER_RUNTIME) save $(IMAGE_NAME) | ipfs add -q > dist/dockerimage-ipfs-hash

cleanup-local:
	$(MAKE) manifest-cleanup REGISTRY=localhost:5000

image-local:
	$(MAKE) image REGISTRY=localhost:5000 PUSH_FLAGS=--tls-verify=false

publish-ipfs-local:
	$(MAKE) publish-ipfs REGISTRY=localhost:5000 PUSH_FLAGS=--tls-verify=false

inspect:
	$(CONTAINER_RUNTIME) manifest inspect $(IMAGE_NAME)

push:
	$(CONTAINER_RUNTIME) push $(IMAGE_NAME)-arm64 $(PUSH_FLAGS)
	# not sure why, but i need to push with specific digest..
	$(CONTAINER_RUNTIME) push $(REGISTRY)/$(REPO)@$(shell $(CONTAINER_RUNTIME) image inspect $(IMAGE_NAME)-arm64 -f '{{.Digest}}') $(PUSH_FLAGS)
	$(CONTAINER_RUNTIME) push $(IMAGE_NAME)-amd64 $(PUSH_FLAGS)
	$(CONTAINER_RUNTIME) push $(REGISTRY)/$(REPO)@$(shell $(CONTAINER_RUNTIME) image inspect $(IMAGE_NAME)-amd64 -f '{{.Digest}}') $(PUSH_FLAGS)
	$(CONTAINER_RUNTIME) manifest push $(IMAGE_NAME) docker://$(IMAGE_NAME) $(PUSH_FLAGS)

clean:
	$(CONTAINER_RUNTIME) rmi $(IMAGE_NAME)
	$(CONTAINER_RUNTIME) rmi $(IMAGE_NAME)-arm64
	$(CONTAINER_RUNTIME) rmi $(IMAGE_NAME)-amd64
