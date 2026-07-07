source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

## XDG
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"

## Editor
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx VIMCONFIG "$XDG_CONFIG_HOME/nvim"

## Go
set -gx GOPATH "$HOME/src/go"
fish_add_path "$GOPATH/bin"

## Podman socket — lets k3d/kind use Podman instead of Docker
set -gx DOCKER_HOST "unix://$XDG_RUNTIME_DIR/podman/podman.sock"
set -gx DOCKER_SOCK "$XDG_RUNTIME_DIR/podman/podman.sock"

## Rust/Cargo
set -gx CARGO_HOME "$XDG_CONFIG_HOME/cargo"
fish_add_path "$CARGO_HOME/bin"

## 1Password SSH agent — serves auth + signing keys via the agent protocol
## (SSH auth, and ssh-keygen -Y sign as used by Codeberg key verification).
## Note: git commit signing goes through op-ssh-sign directly and doesn't need this.
set -gx SSH_AUTH_SOCK "$HOME/.1password/agent.sock"

## Local bin
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/bin"

## Vi mode
fish_vi_key_bindings

## Starship prompt (install: paru -S starship)
if type -q starship
    starship init fish | source
end

## Atuin history (install: paru -S atuin)
if type -q atuin
    atuin init fish --disable-up-arrow | source
end

## Zoxide jump (install: paru -S zoxide)
if type -q zoxide
    zoxide init fish | source
end

## Aliases — editor
abbr -a vim nvim
abbr -a vi nvim

## Aliases — ls (using eza, already installed by CachyOS)
# CachyOS sets ls/ll/la/lt — adding lsd-style lta
alias lta='eza -aT -l --color=always --group-directories-first --icons'

## Aliases — common tools
abbr -a k kubectl
abbr -a tf tofu
abbr -a dhog 'du -cks * | sort -rn'
abbr -a myip 'xh https://ifconfig.co/json'
abbr -a gitroot 'pushd (git root)'
alias dig='dig +noall +answer'
alias tree='tree -Cp -L 2'
