# k3d on rootless Podman

This machine runs Podman as the Docker replacement — `docker` is actually a
Podman 6.x compat shim (`DOCKER_HOST` points at the rootless per-user socket).
k3d has two rough edges on top of that setup, both worked around by
[`bin/k3d-recreate.sh`](../bin/k3d-recreate.sh).

## Symptom

`k3d cluster create` / `k3d cluster start` failed with:

```
Error response from daemon: container create: statfs /var/run/docker.sock: permission denied
```

and after working around that, the server container came up but the API
server was never reachable — `kubectl` timed out and the k3s server log
showed the kubelet crash-looping:

```
Failed to create an oomWatcher (running in UserNS, Hint: enable KubeletInUserNamespace feature flag to ignore the error) err="open /dev/kmsg: operation not permitted"
Error: failed to run Kubelet: failed to create kubelet: open /dev/kmsg: operation not permitted
```

## Root causes

1. **`/var/run/docker.sock` bind-mount, wrong socket.** k3d hardcodes
   bind-mounting the literal path `/var/run/docker.sock` into every node
   container it creates, ignoring `$DOCKER_HOST`. On this machine that path
   is a symlink to `/run/podman/podman.sock` — the *rootful* Podman socket —
   whose parent directory `/run/podman` is `drwx------ root:root` and
   untraversable by a normal user. k3d has its own separate env var,
   `DOCKER_SOCK`, for overriding that mount source; it was never set here, so
   k3d silently fell back to the broken default. This had been a latent bug —
   it didn't matter as long as the rootful socket path happened to be
   reachable — until a Podman 5.8.3 → 6.0.0 upgrade (2026-07-05 reboot)
   tightened up around it and made the fallback path fail outright.

2. **Rootless containers can't access `/dev/kmsg`.** Once `DOCKER_SOCK` is
   fixed, k3d correctly creates node containers through the *rootless* Podman
   engine instead. Rootless containers are confined by an unprivileged user
   namespace and can never get real access to host devices like `/dev/kmsg`,
   which k3s's kubelet wants by default for its OOM watcher. k3s supports this
   exact scenario via a kubelet feature gate,
   `KubeletInUserNamespace=true`, which tells it not to expect that access.

## Fix

Both are handled by the script:

```sh
k3d-recreate.sh [cluster-name]   # defaults to "local"
```

which sets `DOCKER_SOCK=$XDG_RUNTIME_DIR/podman/podman.sock`, recreates the
cluster with `--k3s-arg "--kubelet-arg=feature-gates=KubeletInUserNamespace=true@server:*"`,
and merges the kubeconfig into `~/.kube/config`.

`~/.config/fish/config.fish` also exports `DOCKER_HOST` and `DOCKER_SOCK`
permanently so any other tool that shells out to Docker/Podman (not just
k3d) sees a consistent, working rootless socket.

## References

- k3d Podman guide: https://github.com/k3d-io/k3d/blob/main/docs/usage/advanced/podman.md
- Podman `/run/podman` 0700 default (systemd-tmpfiles, longstanding): https://github.com/containers/podman/issues/27145
- Podman 6.0.0 release notes (no documented change to socket/mount permissions): https://github.com/containers/podman/releases/tag/v6.0.0
