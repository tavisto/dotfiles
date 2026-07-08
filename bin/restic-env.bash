#!/usr/bin/env bash
#
# restic-env.bash  --  SOURCE this, don't execute it.
#
# Exports the RESTIC_* environment (repo URL + REST server creds + repo
# encryption key) by reading them from 1Password at runtime. Both
# restic-backup.bash and restic-verify.bash source this so the credential path
# is defined in exactly one place.
#
# Field mapping verified against the actual 1Password item:
#   username        -> REST server user (boromir)
#   password        -> REST server (htpasswd) password
#   encryption-pass -> repo encryption key (unrecoverable if lost)
#
# Requires the 1Password CLI 'op' with an unlocked session (desktop-app CLI
# integration, or `op signin`). If op can't read a secret, this fails loudly.

# Return-or-exit helper so this works whether sourced or (mis)executed.
_re_fail() { echo "ERROR: $1" >&2; return 1 2>/dev/null || exit 1; }

command -v op >/dev/null || _re_fail "1Password CLI 'op' not found."

export RESTIC_REPOSITORY="rest:https://fangorn.home.tavisto.net:30248/boromir"

_re_item="op://Private/BoromirResticBackup"
RESTIC_REST_USERNAME="$(op read "${_re_item}/username")" \
  || _re_fail "op read failed (username) -- unlock 1Password / enable CLI integration."
RESTIC_REST_PASSWORD="$(op read "${_re_item}/password")" \
  || _re_fail "op read failed (password)."
RESTIC_PASSWORD="$(op read "${_re_item}/encryption-pass")" \
  || _re_fail "op read failed (encryption-pass)."
export RESTIC_REST_USERNAME RESTIC_REST_PASSWORD RESTIC_PASSWORD

[[ -n "$RESTIC_REST_USERNAME" && -n "$RESTIC_REST_PASSWORD" && -n "$RESTIC_PASSWORD" ]] \
  || _re_fail "one or more credentials came back empty from 1Password."

unset _re_item
