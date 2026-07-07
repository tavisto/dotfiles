#!/usr/bin/env bash

# Install packages from Archfile using paru
# Usage: arch-install.sh [path/to/Archfile]

DOTFILES="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
ARCHFILE="${1:-$DOTFILES/Archfile}"

if [ ! -f "$ARCHFILE" ]; then
    echo "Error: Archfile not found at $ARCHFILE" >&2
    exit 1
fi

if ! command -v paru >/dev/null 2>&1; then
    echo "Error: paru is not installed" >&2
    exit 1
fi

grep -v '^#' "$ARCHFILE" | grep -v '^$' | sed 's/[[:space:]]*#.*//' | sed 's/[[:space:]]*$//' | paru -S --needed --noconfirm -
