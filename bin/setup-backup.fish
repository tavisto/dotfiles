#!/usr/bin/env fish
#
# setup-backup.fish  --  SOURCE this in an interactive fish shell:
#     source bin/setup-backup.fish
#
# Exports the RESTIC_* environment (repo URL + REST server creds + repo
# encryption key) from 1Password so you can run `restic ...` by hand in fish.
# This is the fish counterpart of bin/restic-env.bash, which the bash
# backup/verify scripts source. Keep the two in sync.
#
# Field mapping verified against the actual 1Password item:
#   username        -> REST server user (boromir)
#   password        -> REST server (htpasswd) password
#   encryption-pass -> repo encryption key (unrecoverable if lost)
#
# Requires 'op' with an unlocked session (desktop-app CLI integration, or
# `op signin`). Fails loudly (returns non-zero) without exporting anything
# half-set if a secret can't be read.

if not command -q op
    echo "ERROR: 1Password CLI 'op' not found." >&2
    return 1
end

set -l _item "op://Private/BoromirResticBackup"

set -l _user (op read "$_item/username"); or begin
    echo "ERROR: op read failed (username) -- unlock 1Password / enable CLI integration." >&2
    return 1
end
set -l _pass (op read "$_item/password"); or begin
    echo "ERROR: op read failed (password)." >&2
    return 1
end
set -l _key (op read "$_item/encryption-pass"); or begin
    echo "ERROR: op read failed (encryption-pass)." >&2
    return 1
end

if test -z "$_user"; or test -z "$_pass"; or test -z "$_key"
    echo "ERROR: one or more credentials came back empty from 1Password." >&2
    return 1
end

set -gx RESTIC_REPOSITORY "rest:https://fangorn.home.tavisto.net:30248/boromir"
set -gx RESTIC_REST_USERNAME $_user
set -gx RESTIC_REST_PASSWORD $_pass
set -gx RESTIC_PASSWORD $_key

echo "restic env ready: repo=$RESTIC_REPOSITORY user=$RESTIC_REST_USERNAME"
