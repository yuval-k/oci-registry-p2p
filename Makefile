REPO=oci-p2p-registry
REGISTRY=ghcr.io/yuval-k

# REGISTRY=localhost:5000/uvgroovy
# PUSH_FLAGS=--tls-verify=false
COPY_FLAGS=

CONTAINER_RUNTIME=podman

GH_REPO=github.com/yuval-k/oci-registry-p2p
COMMIT=$(shell git rev-parse HEAD)
VERSION=$(shell git describe --tags --always --dirty)
PROJECT_NAME=oci-registry-p2p
TAG=$(VERSION:v%=%)
IMAGE_NAME=$(REGISTRY)/$(REPO):$(TAG)
IPFS_API=$(shell ipfs config Addresses.API)

.PHONY: version
version:
	@echo $(VERSION)

./.bin/helm:
	mkdir -p .bin
	cd tools && go build -o ../.bin/helm helm.sh/helm/v3/cmd/helm

dist/arm64/oci-registry-p2p:
	mkdir -p dist/arm64
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o $@ .

dist/armv7/oci-registry-p2p:
	mkdir -p dist/armv7
	CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 go build -o $@ .

dist/amd64/oci-registry-p2p:
	mkdir -p dist/amd64
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $@ .

dist/arm64/oci-registry-p2p.tar: dist/arm64/oci-registry-p2p
	$(CONTAINER_RUNTIME) build -f Dockerfile --os linux --arch arm64 --variant v8 -t $(IMAGE_NAME)-arm64 --build-arg ARCH=linux/arm64 -f Dockerfile dist/arm64
	$(CONTAINER_RUNTIME) save $(IMAGE_NAME)-arm64 > $@

dist/armv7/oci-registry-p2p.tar: dist/armv7/oci-registry-p2p
	$(CONTAINER_RUNTIME) build -f Dockerfile --os linux --arch arm --variant v7 -t $(IMAGE_NAME)-armv7 --build-arg ARCH=linux/arm/v7 -f Dockerfile dist/armv7
	$(CONTAINER_RUNTIME) save $(IMAGE_NAME)-armv7 > $@

dist/amd64/oci-registry-p2p.tar: dist/amd64/oci-registry-p2p
	$(CONTAINER_RUNTIME) build -f Dockerfile --os linux --arch amd64 -t $(IMAGE_NAME)-amd64 --build-arg ARCH=linux/amd64 -f Dockerfile dist/amd64
	$(CONTAINER_RUNTIME) save $(IMAGE_NAME)-amd64 > $@

install-tools:
	mkdir -p ./.bin
	curl -sSL -O https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz	| tar -zxv
	mv linux-amd64/helm ./.bin/helm

dist/helm/oci-registry-p2p-$(TAG).tgz:
# provide none empty value for ipfs.address so that lint passes
	helm lint --set ipfs.address=a install/helm/oci-registry-p2p
	mkdir -p dist/helm
	helm package install/helm/oci-registry-p2p --destination dist/helm/ --version $(TAG) --app-version $(TAG)

dist/k8s/manifest.yaml:
	mkdir -p dist/k8s
	helm template install/helm/oci-registry-p2p --skip-tests --set tls.createSelfSigned=false --set ipfs.address=/dns4/ipfs.ipfs/tcp/5001 --name-template=release --set image.tag=$(TAG) > $@

helm-package: dist/helm/oci-registry-p2p-$(TAG).tgz

images: dist/arm64/oci-registry-p2p.tar dist/armv7/oci-registry-p2p.tar dist/amd64/oci-registry-p2p.tar

push-images: images
	$(CONTAINER_RUNTIME) manifest rm $(IMAGE_NAME) || exit 0 # cleanup old manifest, if exists
	$(CONTAINER_RUNTIME) manifest create $(IMAGE_NAME)

	$(CONTAINER_RUNTIME) push $(IMAGE_NAME)-arm64 $(PUSH_FLAGS)
	$(CONTAINER_RUNTIME) manifest add $(IMAGE_NAME) $(IMAGE_NAME)-arm64 --os linux --arch arm64 --variant v8 $(PUSH_FLAGS)

	$(CONTAINER_RUNTIME) push $(IMAGE_NAME)-armv7 $(PUSH_FLAGS)
	$(CONTAINER_RUNTIME) manifest add $(IMAGE_NAME) $(IMAGE_NAME)-armv7 --os linux --arch arm --variant v7 $(PUSH_FLAGS)

	$(CONTAINER_RUNTIME) push $(IMAGE_NAME)-amd64 $(PUSH_FLAGS)
	$(CONTAINER_RUNTIME) manifest add $(IMAGE_NAME) $(IMAGE_NAME)-amd64 --os linux --arch amd64 $(PUSH_FLAGS)

	$(CONTAINER_RUNTIME) manifest push $(IMAGE_NAME) docker://$(IMAGE_NAME) $(PUSH_FLAGS)
	$(CONTAINER_RUNTIME) manifest rm $(IMAGE_NAME)

publish-ipfs:
	CID=$(shell ipfs --api=$(IPFS_API) add -Q -r dist); sed -e "s/@CID@/$${CID}/g" -e "s/@TAG@/$(TAG)/g" scripts/README-RELEASE-template.md > README-$(TAG).md
# move the readme to dist folder so it's git ignored and our version is not dirty.
	mv README-$(TAG).md dist/

dist/SHA256SUMS.txt:
	rm $@ || exit 0
	cd dist; sha256sum $$(find . -type f) > SHA256SUMS.txt

publish-gh:
	git push --tags
	gh release create $(VERSION) -F ./dist/README-$(TAG).md

image-dist:
	mkdir -p dist
#	$(CONTAINER_RUNTIME) pull $(IMAGE_NAME) $(PUSH_FLAGS)
#	CGO_ENABLED=0 go run -buildmode=pie -tags containers_image_openpgp github.com/containers/skopeo/cmd/skopeo copy $(COPY_FLAGS) docker://$(IMAGE_NAME) oci:image-test
#	$(CONTAINER_RUNTIME) save $(IMAGE_NAME) > dist/oci-registry-p2p.tar
	$(CONTAINER_RUNTIME) pull $(IMAGE_NAME) $(PUSH_FLAGS)
	$(CONTAINER_RUNTIME) save $(IMAGE_NAME) $(IMAGE_NAME)-arm64 $(IMAGE_NAME)-armv7 $(IMAGE_NAME)-amd64 > dist/oci-registry-p2p.tar

inmemreg-local:
	go run . serve scripts/config-inmem.yaml

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

.PHONY: clean
clean:
	rm -rf ./dist/
.PHONY: clean-images
clean-images:
	$(CONTAINER_RUNTIME) rmi $(IMAGE_NAME)
	$(CONTAINER_RUNTIME) rmi $(IMAGE_NAME)-arm64
	$(CONTAINER_RUNTIME) rmi $(IMAGE_NAME)-amd64