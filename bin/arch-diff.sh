#!/usr/bin/env bash

# Compare Archfile against installed packages
# Usage: arch-diff.sh [path/to/Archfile]

DOTFILES="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
ARCHFILE="${1:-$DOTFILES/Archfile}"

if [ ! -f "$ARCHFILE" ]; then
    echo "Error: Archfile not found at $ARCHFILE" >&2
    exit 1
fi

wanted=$(grep -v '^#' "$ARCHFILE" | grep -v '^$' | sed 's/[[:space:]]*#.*//' | sed 's/[[:space:]]*$//' | sort)
installed=$(pacman -Qq | sort)

missing=$(comm -23 <(echo "$wanted") <(echo "$installed"))
untracked=$(comm -13 <(echo "$wanted") <(pacman -Qeq | sort))

echo "==> In Archfile, not installed:"
if [ -z "$missing" ]; then
    echo "    (none)"
else
    echo "$missing" | sed 's/^/    /'
fi

echo ""
echo "==> Explicitly installed, not in Archfile:"
if [ -z "$untracked" ]; then
    echo "    (none)"
else
    echo "$untracked" | sed 's/^/    /'
fi
