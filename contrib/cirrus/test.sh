#!/bin/bash

set -e

source $(dirname $0)/lib.sh

req_env_vars GOSRC

BIN=bin/oci-seccomp-bpf-hook

cd $GOSRC

# This should have been populated by cache, but if not just build again
if [[ ! -x "$BIN" ]]; then
    warn "$BIN not found, expecting to find it cached as 'gosrc' from build_task"
    msg "Re-building binaries"
    make
fi

[[ -x "bin/oci-seccomp-bpf-hook" ]] || \
    die "Error: Expecting to find bin/"

ls -la bin

msg "Installing oci-seccomp-bpf-hook"
make install PREFIX=/usr

msg "Executing integration tests"
make test-integration BATS_OPTS=--tap
