#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"

if ! command -v paru >/dev/null 2>&1; then
    echo "Error: paru is not installed. Install it first:" >&2
    echo "  sudo pacman -S --needed base-devel && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si" >&2
    exit 1
fi

# Install packages from Archfile
if [ ! -f "$DOTFILES/Archfile" ]; then
    echo "Warning: Archfile not found, skipping package install" >&2
else
    echo "Installing packages from Archfile..."
    "$DOTFILES/bin/arch-install.sh"
fi

# Install Flatpak apps from Flatfile
if [ ! -f "$DOTFILES/Flatfile" ]; then
    echo "Warning: Flatfile not found, skipping flatpak install" >&2
elif ! command -v flatpak >/dev/null 2>&1; then
    echo "Warning: flatpak not installed, skipping flatpak install" >&2
else
    echo "Installing Flatpak apps from Flatfile..."
    "$DOTFILES/bin/flatpak-install.sh"
fi

# Link selected dotfiles into place.
# On this machine most configs are kept native (fish, .gitconfig, .bashrc, etc.);
# only these specific paths are symlinked back to the repo. Add a line here if you
# start tracking another config — do NOT blanket-link everything (that's movin.sh).
echo "Linking selected dotfiles..."
link_dotfile() {
    local src="$DOTFILES/$1" dest="$HOME/${2:-$1}"
    if [ ! -e "$src" ]; then
        echo "  skip (missing in repo): $src" >&2
        return
    fi
    if [ -d "$dest" ] && [ ! -L "$dest" ]; then
        echo "  skip (real dir in the way): $dest" >&2
        return
    fi
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest"
    echo "  $dest -> $src"
}

link_dotfile bin
link_dotfile .config/starship.toml
link_dotfile .config/atuin/config.toml
link_dotfile .config/ghostty/config
link_dotfile .config/fish/config.fish
link_dotfile .gitconfig
link_dotfile .config/git/allowed_signers

# Configure git SSH commit signing via 1Password.
# The signing key + gpg.format=ssh live in the tracked .gitconfig; only the
# OS-specific signer path is machine-local, written here into the untracked
# ~/.config/git/config (which git reads alongside ~/.gitconfig).
if [ -x /opt/1Password/op-ssh-sign ]; then
    echo "Configuring git SSH signing program (1Password)..."
    git config --file "$HOME/.config/git/config" gpg.ssh.program /opt/1Password/op-ssh-sign
else
    echo "Note: /opt/1Password/op-ssh-sign not found — skipping git signing setup" >&2
fi

# Enable Podman socket for k3d compatibility
if command -v podman >/dev/null 2>&1; then
    echo "Enabling Podman socket..."
    systemctl --user enable --now podman.socket
fi

# Create local k3d cluster and set as default kube context
if command -v k3d >/dev/null 2>&1 && command -v kubectl >/dev/null 2>&1; then
    export DOCKER_HOST="unix://${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/podman/podman.sock"
    if k3d cluster list | grep -q '^local '; then
        echo "k3d cluster 'local' already exists, skipping..."
    else
        echo "Creating k3d cluster 'local'..."
        k3d cluster create local \
            --k3s-arg '--kubelet-arg=feature-gates=KubeletInUserNamespace=true@server:*'
    fi
    echo "Setting k3d-local as default kube context..."
    kubectl config use-context k3d-local
fi

# Enable Ollama as a system daemon
if command -v ollama >/dev/null 2>&1; then
    echo "Enabling Ollama service..."
    sudo systemctl enable --now ollama
    sudo usermod -aG ollama "$USER"
fi

# Set ghostty as KDE default terminal
if command -v ghostty >/dev/null 2>&1 && command -v kwriteconfig6 >/dev/null 2>&1; then
    echo "Setting Ghostty as default KDE terminal..."
    kwriteconfig6 --file kdeglobals --group General --key TerminalApplication ghostty
    kwriteconfig6 --file kdeglobals --group General --key TerminalService ghostty
fi

echo "Arch setup completed successfully!"
