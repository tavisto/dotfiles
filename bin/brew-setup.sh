#!/usr/bin/env bash

set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
    echo "Error: Homebrew is not installed or not in PATH" >&2
    exit 1
fi

BREW=$(command -v brew)

if [ ! -f "Brewfile" ]; then
    echo "Warning: Brewfile not found in current directory" >&2
    echo "Skipping bundle installation..."
else
    echo "Installing packages from Brewfile..."
    if ! "$BREW" bundle; then
        echo "Error: Failed to install packages from Brewfile" >&2
        exit 1
    fi
fi

echo "Updating Homebrew..."
if ! "$BREW" update; then
    echo "Error: Failed to update Homebrew" >&2
    exit 1
fi

echo "Upgrading installed packages..."
if ! "$BREW" upgrade; then
    echo "Error: Failed to upgrade packages" >&2
    exit 1
fi

echo "Cleaning up old versions..."
if ! "$BREW" cleanup; then
    echo "Error: Failed to cleanup old versions" >&2
    exit 1
fi

echo "Homebrew setup completed successfully!"
