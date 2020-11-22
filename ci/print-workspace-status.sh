#!/bin/bash

# This file was imported from https://github.com/bazelbuild/bazel at d6fec93.

# This script will be run bazel when building process starts to
# generate key-value information that represents the status of the
# workspace. The output should be like
#
# KEY1 VALUE1
# KEY2 VALUE2
#
# If the script exits with non-zero code, it's considered as a failure
# and the output will be discarded.

# For Envoy in particular, we want to force binaries to relink when the Git
# SHA changes (https://github.com/envoyproxy/envoy/issues/2551). This can be
# done by prefixing keys with "STABLE_". To avoid breaking compatibility with
# other status scripts, this one still echos the non-stable ("volatile") names.

# If this SOURCE_VERSION file exists then it must have been placed here by a
# distribution doing a non-git, source build.
# Distributions would be expected to echo the commit/tag as BUILD_SCM_REVISION
if [ -f SOURCE_VERSION ]
then
    echo "BUILD_SCM_REVISION $(cat SOURCE_VERSION)"
    echo "STABLE_BUILD_SCM_REVISION $(cat SOURCE_VERSION)"
    echo "BUILD_SCM_STATUS Distribution"
    exit 0
fi

# The code below presents an implementation that works for git repository
git_rev=$(git rev-parse HEAD)
if [[ $? != 0 ]];
then
    exit 1
fi

echo "BUILD_SCM_REVISION ${git_rev}"
echo "STABLE_BUILD_SCM_REVISION ${git_rev}"

# Check whether there are any uncommited changes
git diff-index --quiet HEAD --
if [[ $? == 0 ]];
then
    tree_status="Clean"
else
    tree_status="Modified"
fi
echo "BUILD_SCM_STATUS ${tree_status}"
echo "STABLE_BUILD_SCM_STATUS ${tree_status}"
echo "STABLE_DOCKER_REGISTRY ${DOCKER_REGISTRY:-h.yuval.dev/registry}"
echo "STABLE_DOCKER_TAG 0.1.0"
