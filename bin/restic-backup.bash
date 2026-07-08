#!/usr/bin/env bash
#
# restic-backup.bash
#
# One comprehensive, file-level restic backup of this machine to the boromir
# REST repo on fangorn. Intended as a manual, on-demand full backup (e.g. as a
# data floor before a risky disk operation). It does NOT set up any timer,
# service, retention or prune -- run it by hand when you want a snapshot.
#
# Credentials come from 1Password at runtime and are passed to root via the
# environment (never on the command line, so they don't show up in `ps`).
#
# Usage:
#   op signin / unlock the 1Password desktop app first (CLI integration on)
#   sudo -v                       # optional: pre-cache sudo so it won't prompt mid-run
#   bin/restic-backup.bash        # run the backup
#   bin/restic-backup.bash --dry-run   # any extra args are passed through to restic
#
# Notes on scope:
#   The whole system is a single btrfs filesystem split into subvolumes that are
#   mounted separately (/, /home, /root, /var/log, ...). restic sees each
#   subvolume as a different device, so `--one-file-system` alone would stop at
#   every subvolume boundary and silently miss /home etc. We therefore pass each
#   data subvolume as an explicit path AND keep --one-file-system to avoid
#   crossing into pseudo-fs, tmpfs and the /mnt CIFS/NAS automounts.
#
set -euo pipefail

# --- Dry-run detection ------------------------------------------------------
# `--dry-run` / `-n` is passed straight through to restic (which scans and
# reports what *would* be backed up without writing a snapshot). We also detect
# it here to print a clear banner and to skip the sleep inhibitor.
DRY_RUN=0
for _a in "$@"; do
  case "$_a" in --dry-run|-n) DRY_RUN=1 ;; esac
done

# --- Keep the machine awake for the whole run -------------------------------
# Re-exec under systemd-inhibit so idle-suspend/sleep can't interrupt a
# multi-hour backup. The lock is held for this process's lifetime and released
# automatically on exit. Guard var prevents an infinite re-exec loop.
# (Skipped for a dry-run -- it writes nothing and is comparatively quick.)
if [[ "$DRY_RUN" -eq 0 && -z "${RESTIC_INHIBITED:-}" ]] && command -v systemd-inhibit >/dev/null; then
  export RESTIC_INHIBITED=1
  exec systemd-inhibit --what=sleep:idle --why="restic full backup" --mode=block "$0" "$@"
fi

# --- Credentials + repo URL (from 1Password, shared with the verify script) --
echo "==> Reading credentials from 1Password"
source "$(dirname "${BASH_SOURCE[0]}")/restic-env.bash"

# --- What to back up --------------------------------------------------------
PATHS=(
  /
  /home
  /root
  /var/log
)

EXCLUDES=(
  --one-file-system                          # stop at subvolume / pseudo-fs / NAS boundaries
  --exclude-caches                           # honor CACHEDIR.TAG
  --exclude /mnt                             # CIFS/NAS automounts -- never pull over the network
  --exclude /var/cache
  --exclude /var/tmp
  --exclude /tmp
  --exclude '/home/*/.cache'
  --exclude '/home/*/.local/share/Trash'
  --exclude '**/node_modules'
  # container image / layer storage (re-pullable)
  --exclude /var/lib/containers
  --exclude /var/lib/docker
  --exclude '/home/*/.local/share/containers'
  # ollama models / caches (re-pullable)
  --exclude /usr/share/ollama
  --exclude /var/lib/ollama
  --exclude '/home/*/.ollama'
)

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "==> DRY RUN: scanning only -- NO snapshot is created and nothing is uploaded."
fi
echo "==> Backing up paths: ${PATHS[*]}"
echo "==> Repository:      $RESTIC_REPOSITORY"

# --- Run restic as root, preserving only the RESTIC_* creds in the env ------
# root is needed to read all files (other users' homes, /etc secrets, etc.).
# If SUDO_ASKPASS is set (e.g. an `op read` helper) use `sudo -A` so the run is
# non-interactive; otherwise plain sudo prompts on the terminal as usual.
SUDO=(sudo)
[[ -n "${SUDO_ASKPASS:-}" ]] && SUDO=(sudo -A)
"${SUDO[@]}" --preserve-env=RESTIC_REPOSITORY,RESTIC_REST_USERNAME,RESTIC_REST_PASSWORD,RESTIC_PASSWORD \
  restic backup "${PATHS[@]}" "${EXCLUDES[@]}" --verbose "$@"
