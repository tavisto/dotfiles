# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a personal dotfiles repository containing shell configurations, terminal tools, and development environment setup scripts. The structure is organized as follows:

- `zsh/` - Zsh shell configuration files including .zshrc, .zshenv, aliases, and completions
- `bin/` - Utility scripts for system setup, automation, and development workflows
- `.config/` - Application configuration files (WezTerm terminal, Starship prompt)
- `Brewfile` - Homebrew package manager configuration for macOS development tools
- `requirements.txt` - Python development tools for linting and code quality

## Key Configuration Files

- `.zshrc` - Main zsh configuration with plugin management, completion setup, and vim mode
- `.zshenv` - Environment variables and XDG directory configuration
- `aliases.zsh` - Command aliases including modern CLI tool replacements
- `wezterm.lua` - Terminal emulator configuration with custom keybindings and themes
- `.gitconfig` - Git configuration with delta diff viewer and signing setup
- `.tool-versions` - ASDF version manager configuration for multiple runtime environments

## Common Development Tasks

### Package Management
- Install/update packages: `brew bundle` (uses Brewfile)
- Update brew packages: `./bin/brew-setup.sh`
- Python tools are managed via `requirements.txt`

### Environment Setup
- Runtime versions managed via ASDF with `.tool-versions`
- Languages configured: Node.js, Ruby, Python, Rust, Go, OpenTofu
- Shell setup uses zplug for plugin management and Starship for prompt

### Key Tools and Aliases
- `ls` → `lsd` (modern ls replacement)
- `k` → `kubectl` (Kubernetes CLI)
- `tf` → `tofu` (OpenTofu/Terraform)
- `vim`/`vi` → `nvim` (Neovim editor)
- Git aliases: `glog`, `vlog`, `klog` for enhanced git log viewing

## Shell Configuration Architecture

The zsh configuration follows XDG directory standards:
- `ZDOTDIR` set to `$XDG_CONFIG_HOME/zsh`
- History, functions, and completions organized under config directories
- Modular approach with separate files for aliases, local configs, and specific tools

The shell setup includes:
- Vi mode with custom keybindings
- Enhanced completion system with case-insensitive matching
- Directory stack navigation with numeric shortcuts
- Integration with modern tools (atuin for history, starship for prompt)

## Development Environment

Tools are managed through multiple package managers:
- Homebrew for system tools and applications
- ASDF for runtime version management
- Python pip for development tools
- Git LFS for large file handling

The environment is optimized for:
- Cloud native development (k8s, helm, terraform)
- Go development with proper GOPATH setup
- Multi-language support via ASDF
- Enhanced terminal experience with modern CLI tools