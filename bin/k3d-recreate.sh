#!/usr/bin/env bash

# Recreate a k3d cluster on rootless Podman.
# Usage: k3d-recreate.sh [cluster-name]
#
# Two rootless-Podman quirks this works around:
# - k3d hardcodes bind-mounting /var/run/docker.sock into its node containers,
#   ignoring $DOCKER_HOST. DOCKER_SOCK is k3d's own env var for overriding that
#   mount source; without it k3d falls back to /var/run/docker.sock, which on
#   this machine is a symlink into the rootful Podman socket dir (0700 root),
#   so container creation fails with "statfs: permission denied".
# - Rootless containers can never get real access to host devices like
#   /dev/kmsg, which k3s's kubelet wants by default, crashing with
#   "open /dev/kmsg: operation not permitted". The KubeletInUserNamespace
#   feature gate tells kubelet not to expect that access.

set -euo pipefail

CLUSTER="${1:-local}"

export DOCKER_SOCK="${XDG_RUNTIME_DIR}/podman/podman.sock"

if k3d cluster list "$CLUSTER" >/dev/null 2>&1; then
    k3d cluster delete "$CLUSTER"
fi

k3d cluster create "$CLUSTER" \
    --k3s-arg "--kubelet-arg=feature-gates=KubeletInUserNamespace=true@server:*"

k3d kubeconfig merge "$CLUSTER" --kubeconfig-merge-default --kubeconfig-switch-context
