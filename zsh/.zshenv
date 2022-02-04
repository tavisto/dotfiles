#!/usr/bin/env zsh

# Set the default config directory to keep a clean home dir.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Make sure my custom functions can load
export FPATH="${ZDOTDIR}:${FPATH}"
export FPATH="${ZDOTDIR}/completion.d:${FPATH}"

# Make sure we ste up neovim as our default editor.
export EDITOR="nvim"
export VISUAL="nvim"

# Set up all the colorful listings
export CLICOLOR=1
export LSCOLORs=exfxcxdxbxegedabagacad
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# history is doomed to repeat itself
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

# Make sure neovim knows where to go
export VIMCONFIG="$XDG_CONFIG_HOME/nvim"

# Go dog go
export GOPATH="$HOME/src/go"
export PATH="$PATH:$GOPATH/bin"
. "$HOME/.cargo/env"
