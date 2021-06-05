build:
	bazel build --platforms=@io_bazel_rules_go//go/toolchain:linux_arm64 //ci:registry
	bazel build --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64 //ci:registry

TAG=0.2.1
REPO=p2p-registry
REGISTRY=docker.io/uvgroovy
PUSH_FLAGS=

# REGISTRY=localhost:5000/uvgroovy
# PUSH_FLAGS=--tls-verify=false


add-img-arm64:
	GOARCH=arm64 go build -o oci-registry-p2p .
	podman build -f Dockerfile --platform linux/arm64 --os linux --arch arm64 -t $(REGISTRY)/$(REPO):$(TAG)-arm64 .
	podman manifest add $(REGISTRY)/$(REPO):$(TAG) $(REGISTRY)/$(REPO):$(TAG)-arm64 --variant v8 --os linux --arch arm64

add-img-amd64:
	GOARCH=amd64 go build -o oci-registry-p2p .
	podman build -f Dockerfile --platform linux/amd64 --os linux --arch amd64 -t $(REGISTRY)/$(REPO):$(TAG)-amd64 .
	podman manifest add $(REGISTRY)/$(REPO):$(TAG) $(REGISTRY)/$(REPO):$(TAG)-amd64 --os linux --arch amd64

image:
	podman manifest create $(REGISTRY)/$(REPO):$(TAG)
	$(MAKE) add-img-arm64
	$(MAKE) add-img-amd64

inspect:
	podman manifest inspect $(REGISTRY)/$(REPO):$(TAG)

push:
	podman push $(REGISTRY)/$(REPO):$(TAG)-arm64 $(PUSH_FLAGS)
	# not sure why, but i need to push with specific digest..
	podman push $(REGISTRY)/$(REPO)@$(shell podman image inspect $(REGISTRY)/$(REPO):$(TAG)-arm64 -f '{{.Digest}}') $(PUSH_FLAGS)
	podman push $(REGISTRY)/$(REPO):$(TAG)-amd64 $(PUSH_FLAGS)
	podman push $(REGISTRY)/$(REPO)@$(shell podman image inspect $(REGISTRY)/$(REPO):$(TAG)-amd64 -f '{{.Digest}}') $(PUSH_FLAGS)
	podman manifest push $(REGISTRY)/$(REPO):$(TAG) docker://$(REGISTRY)/$(REPO):$(TAG) $(PUSH_FLAGS)

clean:
	podman rmi $(REGISTRY)/$(REPO):$(TAG)
	podman rmi $(REGISTRY)/$(REPO):$(TAG)-arm64
	podman rmi $(REGISTRY)/$(REPO):$(TAG)-amd64

releaser-test:
	go run github.com/goreleaser/goreleaser --snapshot --skip-publish --rm-dist

release:
	go run github.com/goreleaser/goreleaser release --rm-dist
