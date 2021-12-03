#!/usr/bin/env zsh

###############################
# Set up some exports
###############################

# Set the default config directory to keep a clean home dir.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Make sure we ste up neovim as our default editor.
export EDITOR="nvim"
export VISUAL="nvim"

export CLICOLOR=1

export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file
export VIMCONFIG="$XDG_CONFIG_HOME/nvim"

export GOPATH="$HOME/src/go"
