#!/usr/bin/env bash

# Install apps from Flatfile using flatpak (Flathub)
# Usage: flatpak-install.sh [path/to/Flatfile]

DOTFILES="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
FLATFILE="${1:-$DOTFILES/Flatfile}"

if [ ! -f "$FLATFILE" ]; then
    echo "Error: Flatfile not found at $FLATFILE" >&2
    exit 1
fi

if ! command -v flatpak >/dev/null 2>&1; then
    echo "Error: flatpak is not installed" >&2
    exit 1
fi

# Ensure the Flathub remote exists
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

grep -v '^#' "$FLATFILE" | grep -v '^$' | sed 's/[[:space:]]*#.*//' | sed 's/[[:space:]]*$//' \
    | xargs -r flatpak install --noninteractive --or-update flathub
