#!/bin/bash

set -e
set -x

PROJ_DIR=$(dirname $(go env GOMOD))
go build -o ${PROJ_DIR}/oci-registry-p2p ${PROJ_DIR}

# build using stdin, as we dont need build context.
cat ${PROJ_DIR}/scripts/Dockerfile.systemdtest | podman build -f - -t testsystemd 

# don't even bother with "-p 5000:5000", as we just test that systemd can start us
CID=$(podman run -d --rm --name systemdtest -v ${PROJ_DIR}/oci-registry-p2p:/usr/local/bin/oci-registry-p2p:ro \
    -v ${PROJ_DIR}/scripts/example-config.yaml:/etc/oci-registry-p2p/config.yaml:ro \
    -v ${PROJ_DIR}/test/e2e/cert.pem:/etc/oci-registry-p2p/cert.pem:ro \
    -v ${PROJ_DIR}/test/e2e/key.pem:/etc/oci-registry-p2p/key.pem:ro \
    -v ${PROJ_DIR}/install/oci-registry-p2p.service:/etc/systemd/system/oci-registry-p2p.service:ro \
    testsystemd)

trap "podman stop $CID" EXIT

podman exec $CID /bin/sh -c "systemctl daemon-reload && systemctl enable oci-registry-p2p && systemctl start oci-registry-p2p"


podman exec $CID /bin/sh -c "journalctl -u oci-registry-p2p"

# registry will fail to start because ipfs is not there. that's ok, as we are just testing that systemd
# is able to start it. if in the future we can get it to work, we can try "curl localhost:5000/v2/_catalog" to confirm.
