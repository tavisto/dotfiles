#!/usr/bin/env bash
#
# update-fangorn-creds.sh
#
# Regenerate /etc/samba/credentials/fangorn from 1Password, then remount the
# fangorn CIFS shares. Secrets never touch the repo — only op:// references do.
#
# Usage:
#   op signin                 # if not already authenticated
#   sudo -v                   # cache sudo credentials up front
#   bin/update-fangorn-creds.sh
#
set -euo pipefail

# --- 1Password secret references (edit vault/item to match yours) ------------
OP_USER_REF="op://Private/fangorn-nas/username"
OP_PASS_REF="op://Private/fangorn-nas/password"

CRED_DIR=/etc/samba/credentials
CRED_FILE="$CRED_DIR/fangorn"
SHARES=(media archives photos backups)

command -v op >/dev/null || { echo "ERROR: 1Password CLI 'op' not found." >&2; exit 1; }

echo "==> Reading credentials from 1Password"
if ! op account get >/dev/null 2>&1; then
  echo "ERROR: not signed in to 1Password. Run 'op signin' (or 'eval \$(op signin)') first." >&2
  exit 1
fi
USERNAME="$(op read "$OP_USER_REF")"
PASSWORD="$(op read "$OP_PASS_REF")"
[[ -n "$USERNAME" && -n "$PASSWORD" ]] || { echo "ERROR: empty username/password from 1Password." >&2; exit 1; }

echo "==> Writing $CRED_FILE (mode 600, root-owned)"
sudo install -d -m 700 "$CRED_DIR"
# Write atomically via a root-owned temp file, then move into place.
TMP="$(sudo mktemp "${CRED_DIR}/.fangorn.XXXXXX")"
printf 'username=%s\npassword=%s\n' "$USERNAME" "$PASSWORD" | sudo tee "$TMP" >/dev/null
sudo chmod 600 "$TMP"
sudo chown root:root "$TMP"
sudo mv -f "$TMP" "$CRED_FILE"

echo "==> Remounting shares"
for s in "${SHARES[@]}"; do
  # Drop any stale/failed mount, then let the automount re-trigger on access.
  sudo umount "/mnt/minastirith/$s" 2>/dev/null || true
  sudo systemctl reset-failed "mnt-minastirith-$s.mount" 2>/dev/null || true
done
sudo systemctl daemon-reload
for s in "${SHARES[@]}"; do
  sudo systemctl restart "mnt-minastirith-$s.automount" 2>/dev/null || true
  ls "/mnt/minastirith/$s" >/dev/null 2>&1 || true   # trigger the automount
done

echo "--- mounted CIFS ---"
mount | grep minastirith || echo "(nothing mounted — is fangorn reachable?)"
echo "==> Done."
