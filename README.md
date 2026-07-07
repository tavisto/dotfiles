# Dotfiles

Personal development environment for macOS, Arch/CachyOS, and Ubuntu — shell config, CLI tooling, container/K8s setup, and multi-language runtimes.

## Quick Start

### macOS

```sh
brew bundle          # install all packages
brew upgrade         # update everything
./bin/brew-setup.sh  # full brew cycle (bundle + update + upgrade + cleanup)
```

### Arch / CachyOS

`paru` ships with CachyOS; on plain Arch install it first. Then:

```sh
./bin/arch-setup.sh     # full bootstrap: Archfile + Flatfile + services + k3d + ollama
./bin/arch-install.sh   # packages only (Archfile -> paru --needed)
./bin/flatpak-install.sh # flatpak apps only (Flatfile -> Flathub)
./bin/arch-diff.sh      # show drift between Archfile and installed packages
./bin/movin.sh -b       # link dotfiles into ~ (backs up existing with -b, or -c to clean first)
```

`Archfile` tracks pacman/AUR packages (including Neovim language servers) and `Flatfile` tracks Flathub apps — both are the source of truth for a re-image.

## Prerequisites

- macOS with [Homebrew](https://brew.sh/) or Ubuntu 22+
- [ASDF](https://asdf-vm.com/) for runtime version management
- SSH keys configured (setup scripts include remote deployment helper)

## Layout

| Path | What it does |
|---|---|
| `Brewfile` | Homebrew taps, CLI tools, and cask apps — the single source of truth for `brew bundle` (macOS) |
| `Archfile` | Arch/CachyOS pacman + AUR packages, including Neovim language servers — source of truth for `arch-install.sh` |
| `Flatfile` | Flathub application IDs — source of truth for `flatpak-install.sh` |
| `zsh/` | Shell config: `.zshenv`, `.zshrc`, aliases, login/logout, plus a fortune utility and custom completion |
| `bin/` | Utility scripts for setup, K8s, Ollama, npm, Git, DNS, and more (see below) |
| `docs/` | Notes on non-obvious fixes/setups (see below) |
| `.config/` | App-level config: WezTerm terminal, Starship prompt, etc. |
| `.gitconfig` | Git config with Delta as diff viewer, signing keys, aliases (`glog`, `vlog`, `klog`) |
| `.tool-versions` | ASDF version pins across Go 1.24, Node 23, Python 3.12, Ruby 3.3, Rust 1.89, Terraform/OpenTofu |
| `requirements.txt` | Python dev tools for linting (ruff, flake8, mypy, etc.) |

## Shell & Terminal

- **Zsh** with `.zshenv` (env vars), `.zshrc` (aliases/fn/config), `.zlogin`/`.zlogout`
- [Starship](https://starship.rs/) prompt with custom theme
- Vi mode, history persistence via [atuin](https://github.com/atuin-sh/atuin), directory stack shortcuts (`pushd`/`popd`)
- XDG-compatible zsh config path (`$XDG_CONFIG_HOME/zsh`)

## Development Runtimes

Installed and managed via ASDF (see `.tool-versions`):

| Language | Version |
|---|---|
| Go | 1.24.2 |
| Node.js | 23.7.0 |
| Python | 3.12.9 |
| Ruby | 3.3.6 |
| Rust | 1.89.0 |
| OpenTofu | 1.8.8 |

## Key Tools (a sampling)

- **Shell:** fzf, bat, fd, tokei, dust, lsd; zsh with `--auto-tag` completions + `--no-cache`, case-insensitive fuzzy matching (`zsh/completion`)
- **Dev Tools:** neovim (plugin manager: minpac)
- **Git:** Delta (`git-delta` for diffs, `gh` CLI, `jj`)
- **Kubernetes:** kubectl, helm, argocd, k9s, kustomize, kubebuilder (via cli), `stern`, `skaffold`, `kind`, `k3d`, `colima`, `minikube`
- **Infra-as-Code:** terraform, tofu, gitversion (`terraform-docs`, `tflint`)
- **Go dev:** goimports, delve/`errcheck`, `gopls`, `fillstruct`
- **Networking:** curl, websocat, `hey` (load testing), `siege` (HTTP load testing)

## bin/ Scripts

| Script | Purpose |
|---|---|
| [arch-diff.sh](bin/arch-diff.sh) | Show drift between the Archfile and explicitly-installed pacman packages |
| [arch-install.sh](bin/arch-install.sh) | Install/sync packages from the Archfile via `paru -S --needed` |
| [arch-setup.sh](bin/arch-setup.sh) | Full Arch/CachyOS bootstrap: Archfile + Flatfile installs, Podman socket, k3d cluster, Ollama daemon, Ghostty as KDE terminal |
| [asdf-setup.sh](bin/asdf-setup.sh) | Install asdf-rust plugin + latest Rust/Cargo |
| [flatpak-install.sh](bin/flatpak-install.sh) | Install apps from the Flatfile (adds Flathub remote, then `flatpak install`) |
| [autossh.sh](bin/autossh.sh) | Set up persistent SSH SOCKS tunnel to a remote host |
| [brew-setup.sh](bin/brew-setup.sh) | Full Homebrew lifecycle: `brew bundle`, `update`, `upgrade`, `cleanup` (with error handling) |
| [clear-dns.sh](bin/clear-dns.sh) | Flush DNS cache on macOS (`dscacheutil`) + restart mDNSResponder |
| [colortest](bin/colortest) | 256-color xterm palette tester (Perl script, wide/reversed display modes) |
| [bash_colors.sh](bin/bash_colors.sh) | Echoes terminal color codes for foreground/background combos |
| [convert-git-sha256.sh](bin/convert-git-sha256.sh) | Convert a Git repo from SHA-1 to SHA-256 (export → re-init → fast-import) |
| [fastgpt.sh](bin/fastgpt.sh) | Query Kagi FastGPT API, pipe through glow for pretty terminal output |
| [fix-ollama-mlx.sh](bin/fix-ollama-mlx.sh) | Post-brew-upgrade fix: symlink MLX libraries into ollama's cellar path and restart service |
| [fix-repo-author.sh](bin/fix-repo-author.sh) | Rewrite old author/committer email across all branches and tags via `git filter-branch` |
| [install-dotfiles.sh](bin/install-dotfiles.sh) | SCP dotfiles tarball to a remote host and run `movin.sh` to symlink configs |
| [k8s-context-do.sh](bin/k8s-context-do.sh) | List pods by node label, with optional `--context` flag for kubeconfig contexts |
| [k8s-pods-by-node.sh](bin/k8s-pods-by-node.sh) | Core K8s helper: lists pods per node (excludes DaemonSets), accepts `-c` context flag |
| [k3d-recreate.sh](bin/k3d-recreate.sh) | Recreate a k3d cluster on rootless Podman with the env var and kubelet feature gate it needs (see [docs/k3d-rootless-podman.md](docs/k3d-rootless-podman.md)) |
| [movin.sh](bin/movin.sh) | Dotfiles linker — backs up existing files (`-b`) or cleans them (`-c`) before symlinking everything from this repo into `~` |
| [npm-global-dump.sh](bin/npm-global-dump.sh) | Dumps currently installed global npm packages into a `package.json` for backup/restore |
| [npm-global.sh](bin/npm-global.sh) | Installs all packages listed in a `package.json` globally (`npm install -g`) |
| [test-models.sh](bin/test-models.sh) | Benchmark local Ollama models: runs a fibonacci completion prompt, reports latency (ms) and throughput (tokens/sec) |
| [ubuntu-setup.sh](bin/ubuntu-setup.sh) | One-command Ubuntu bootstrap: installs neovim/fzf, clones nvim config, runs `PackUpdate` |
| [x-man-page.sh](bin/x-man-page.sh) | Quick helper to look up man pages with section numbers (e.g. `x-man-page.sh 5 date`) |

## docs/

| Doc | What it covers |
|---|---|
| [k3d-rootless-podman.md](docs/k3d-rootless-podman.md) | Why k3d breaks on rootless Podman (docker.sock bind-mount, kubelet/`/dev/kmsg`) and how `k3d-recreate.sh` fixes it |

## How It Works

1. **`brew bundle`** installs all Homebrew packages/Casks from the Brewfile.
2. **ASDF** manages language runtimes — `.tool-versions` pins specific versions for reproducible builds across projects.
3. **Shell config** is modular: env vars in `.zshenv`, interactive config/aliases in `.zshrc`, login/logout hooks in `.zlogin`/`.zlogout`.
4. **Custom `bin/` scripts** are meant to be either sourced or executed directly; they live on your `$PATH` and handle day-to-day dev tasks (K8s queries, Ollama testing, npm package snapshotting, DNS cache flushing, etc.).
