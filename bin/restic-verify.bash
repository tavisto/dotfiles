#!/usr/bin/env bash
#
# restic-verify.bash
#
# Hard verification of the boromir restic repo, meant to be run right after
# restic-backup.bash as pre-destructive-operation insurance. It:
#   1. lists snapshots and identifies the latest one,
#   2. shows stats (restore-size + deduplicated) and sanity-checks the size,
#   3. runs a FULL `restic check --read-data` (re-reads every pack -- slow),
#   4. proves a real restore: restores one /etc file and one /home file to
#      /tmp/restore-verify and diffs them against the live originals.
# It prints a clear PASS/FAIL summary and exits non-zero if anything failed.
#
# This is read-only against the repo and needs no root. Restored /etc files are
# written under an unprivileged target, so restic will warn it can't chown them
# -- that's expected; the diff of the file *contents* is the real proof.
#
# Config via env (all optional):
#   READ_DATA_MODE   full (default) | a percentage like "20%" for a subset check
#   ETC_FILE         /etc file to restore-test (default: /etc/fstab)
#   HOME_FILE        /home file to restore-test (default: auto-picked dotfile)
#   RESTORE_TARGET   where to restore for the diff (default: /tmp/restore-verify)
#
# Usage:
#   bin/restic-verify.bash
#   READ_DATA_MODE=20% bin/restic-verify.bash     # faster subset integrity check
#
set -uo pipefail   # deliberately NOT -e: we collect step results and report them

# Keep the machine awake -- the full --read-data check can run for hours.
# Re-exec under systemd-inhibit (auto-released on exit); guard prevents a loop.
if [[ -z "${RESTIC_INHIBITED:-}" ]] && command -v systemd-inhibit >/dev/null; then
  export RESTIC_INHIBITED=1
  exec systemd-inhibit --what=sleep:idle --why="restic verify (check --read-data)" --mode=block "$0" "$@"
fi

source "$(dirname "${BASH_SOURCE[0]}")/restic-env.bash"

READ_DATA_MODE="${READ_DATA_MODE:-full}"
ETC_FILE="${ETC_FILE:-/etc/fstab}"
RESTORE_TARGET="${RESTORE_TARGET:-/tmp/restore-verify}"

# --- pick a stable, pre-existing /home file if none was given ---------------
if [[ -z "${HOME_FILE:-}" ]]; then
  for c in "$HOME/.bashrc" "$HOME/.profile" "$HOME/.config/fish/config.fish" \
           "$HOME/.gitconfig" "$HOME/.bash_profile"; do
    [[ -f "$c" ]] && { HOME_FILE="$c"; break; }
  done
fi
if [[ -z "${HOME_FILE:-}" ]]; then
  HOME_FILE="$(find "$HOME" -maxdepth 2 -type f -size -1M -readable 2>/dev/null | head -n1)"
fi

# --- result tracking --------------------------------------------------------
declare -a RESULTS
record() { RESULTS+=("$1|$2"); }   # STATUS|message
OVERALL=0
fail() { OVERALL=1; }

hr() { printf '=%.0s' {1..72}; echo; }

# --- 1. snapshots -----------------------------------------------------------
hr; echo "STEP 1/4  restic snapshots"; hr
if restic snapshots; then
  SNAP_ID="$(restic snapshots latest --json 2>/dev/null \
    | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d[-1]["short_id"] if d else "")' 2>/dev/null)"
  if [[ -n "$SNAP_ID" ]]; then
    record PASS "snapshots listed; latest = $SNAP_ID"
  else
    record FAIL "no snapshot found in repo"; fail
  fi
else
  record FAIL "restic snapshots failed (connectivity/creds)"; fail
fi

# --- 2. stats + size sanity -------------------------------------------------
hr; echo "STEP 2/4  restic stats latest"; hr
echo "-- restore-size (logical size of files) --"
restic stats latest
echo "-- raw-data (deduplicated bytes stored) --"
restic stats latest --mode raw-data

TOTAL_BYTES="$(restic stats latest --json 2>/dev/null \
  | python3 -c 'import sys,json; print(json.load(sys.stdin).get("total_size",0))' 2>/dev/null)"
FILE_COUNT="$(restic stats latest --json 2>/dev/null \
  | python3 -c 'import sys,json; print(json.load(sys.stdin).get("total_file_count",0))' 2>/dev/null)"
POOL_USED="$(df -B1 --output=used / 2>/dev/null | tail -n1 | tr -d ' ')"

echo
python3 - "$TOTAL_BYTES" "$FILE_COUNT" "$POOL_USED" <<'PY'
import sys
tot=int(sys.argv[1] or 0); files=int(sys.argv[2] or 0); pool=int(sys.argv[3] or 0)
def h(n):
    for u in "B KiB MiB GiB TiB".split():
        if n<1024: return f"{n:.1f} {u}"
        n/=1024
    return f"{n:.1f} PiB"
print(f"backup restore-size : {h(tot)}  ({files} files)")
print(f"filesystem pool used: {h(pool)}  (includes excluded caches/containers/ollama)")
PY

# Sanity floor: a real full-machine backup of this box should be tens+ of GiB.
FLOOR=$((20 * 1024 * 1024 * 1024))   # 20 GiB
if [[ -z "$TOTAL_BYTES" || "$TOTAL_BYTES" -eq 0 ]]; then
  record FAIL "could not read backup size from stats"; fail
elif [[ "$TOTAL_BYTES" -lt "$FLOOR" ]]; then
  record FAIL "backup size implausibly small (< 20 GiB) -- likely over-excluded"; fail
else
  record PASS "size plausible ($((TOTAL_BYTES/1024/1024/1024)) GiB, $FILE_COUNT files)"
fi

# --- 3. full integrity check (re-read all pack data) ------------------------
hr; echo "STEP 3/4  restic check ($([[ "$READ_DATA_MODE" == full ]] && echo '--read-data' || echo "--read-data-subset=$READ_DATA_MODE"))"; hr
if [[ "$READ_DATA_MODE" == "full" ]]; then
  CHECK_ARG=(--read-data)
else
  CHECK_ARG=(--read-data-subset="$READ_DATA_MODE")
fi
if restic check "${CHECK_ARG[@]}"; then
  record PASS "integrity check clean ($READ_DATA_MODE read)"
else
  record FAIL "restic check reported errors"; fail
fi

# --- 4. real restore + diff proof ------------------------------------------
hr; echo "STEP 4/4  restore-and-diff proof"; hr
rm -rf "$RESTORE_TARGET"; mkdir -p "$RESTORE_TARGET"
echo "Restoring $ETC_FILE and $HOME_FILE -> $RESTORE_TARGET"
# chown warnings on the root-owned /etc file are expected & harmless here.
restic restore latest --target "$RESTORE_TARGET" \
  --include "$ETC_FILE" --include "$HOME_FILE" 2>&1 | tail -n 20 || true

diff_one() {
  local orig="$1" restored="$RESTORE_TARGET$1"
  if [[ ! -f "$restored" ]]; then
    record FAIL "restore missing: $1 (not written under target)"; fail; return
  fi
  if diff -q "$restored" "$orig" >/dev/null 2>&1; then
    record PASS "restore matches original: $1"
    echo "  OK  $1  ($(wc -c <"$orig") bytes, identical)"
  else
    record FAIL "restore DIFFERS from original: $1"; fail
    echo "  DIFF $1"; diff "$restored" "$orig" | head -n 20
  fi
}
diff_one "$ETC_FILE"
[[ -n "${HOME_FILE:-}" ]] && diff_one "$HOME_FILE" || { record FAIL "no /home file available to test"; fail; }

# --- summary ----------------------------------------------------------------
echo; hr; echo "VERIFICATION SUMMARY"; hr
for r in "${RESULTS[@]}"; do
  printf '  [%s] %s\n' "${r%%|*}" "${r#*|}"
done
hr
if [[ "$OVERALL" -eq 0 ]]; then
  echo "RESULT: PASS -- backup verified. Snapshot: ${SNAP_ID:-?}"
else
  echo "RESULT: FAIL -- DO NOT rely on this backup; investigate above."
fi
exit "$OVERALL"
