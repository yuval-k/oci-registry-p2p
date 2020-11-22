load("@io_bazel_rules_docker//container:container.bzl", "container_pull")

def define_base_images():
    ## Use 'static' distroless image for all builds
    container_pull(
        name = "static_base",
        registry = "gcr.io",
        repository = "distroless/static",
        digest = "sha256:cd0679a54d2abaf3644829f5e290ad8a10688847475f570fddb9963318cf9390",
    )