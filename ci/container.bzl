load("@io_bazel_rules_docker//container:container.bzl", "container_bundle", "container_image")
load("@io_bazel_rules_docker//contrib:push-all.bzl", "container_push")
load("@io_bazel_rules_docker//go:image.bzl", "go_image")
load(":platforms.bzl", "go_platform_constraint")
load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")

def multi_arch_container(
        name,
        architectures,
        base,
        container_tags,
        stamp = True,
        container_push_tags = None,
        tags = None,
        visibility = None,
        user = "0",
        **kwargs):

    go_image(
        name = "%s-internal-notimestamp" % name,
        base = select({
            go_platform_constraint(os = "linux", arch = arch): base.format(ARCH = arch)
            for arch in architectures
        }),
        stamp = stamp,
        tags = tags,
        user = user,
        visibility = ["//visibility:private"],
        **kwargs
    )

    # Create a tar file containing the created license files
    pkg_tar(
        name = "%s.license_tar" % name,
        # srcs = ["//:LICENSE", "//:LICENSES"],
        srcs = ["//:LICENSE"],
        package_dir = "licenses",
    )

    container_image(
        name = "%s.image" % name,
        base = ":%s-internal-notimestamp" % name,
        tars = [":%s.license_tar" % name],
        stamp = stamp,
        tags = tags,
        user = user,
        visibility = ["//visibility:public"],
    )

    for arch in architectures:
        container_bundle(
            name = "%s-%s" % (name, arch),
            images = {
                container_tag.format(ARCH = arch): ":%s.image" % name
                for container_tag in container_tags
            },
            tags = tags,
            visibility = visibility,
        )
    native.alias(
        name = name,
        tags = tags,
        actual = select({
            go_platform_constraint(os = "linux", arch = arch): "%s-%s" % (name, arch)
            for arch in architectures
        }),
    )
    native.genrule(
        name = "gen_%s.tar" % name,
        outs = ["%s.tar" % name],
        tags = tags,
        srcs = select({
            go_platform_constraint(os = "linux", arch = arch): ["%s-%s.tar" % (name, arch)]
            for arch in architectures
        }),
        cmd = "cp $< $@",
        output_to_bindir = True,
    )

    if container_push_tags:
        multi_arch_container_push(
            name = name,
            architectures = architectures,
            container_tags_images = {container_push_tag: ":%s.image" % name for container_push_tag in container_push_tags},
            tags = tags,
        )


def multi_arch_container_push(
        name,
        architectures,
        container_tags_images,
        tags = None):
    for arch in architectures:
        container_bundle(
            name = "push-%s-%s" % (name, arch),
            images = {tag.format(ARCH = arch): image for tag, image in container_tags_images.items()},
            tags = tags,
            visibility = ["//visibility:private"],
        )

    native.alias(
        name = name,
        tags = tags,
        actual = select({
            go_platform_constraint(os = "linux", arch = arch): "push-%s-%s" % (name, arch)
            for arch in architectures
        }),
    )

    container_push(
        name = "push-%s" % name,
        tags = tags,
        format = "OCI",
        bundle = select({
            go_platform_constraint(os = "linux", arch = arch): "push-%s-%s" % (name, arch)
            for arch in architectures
        }),
    )
