#!/usr/bin/env zsh


# Do the PATH manipulation here after the OS level stuff has already run
# Go dog go
export GOPATH="$HOME/src/go"
export PATH="$PATH:$GOPATH/bin"

# Add local bin
export PATH="$PATH:${HOME}/bin:$PATH"

# Set up homebrew
eval $(/opt/homebrew/bin/brew shellenv)

# Set up asdf
export ASDF_DATA_DIR="$XDG_CONFIG_HOME/asdf"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Prepend asdf shim paths to PATH
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:${ASDF_DATA_DIR:-$HOME/.asdf}/bin:$PATH"

# Setup zplug
export ZPLUG_HOME="${HOMEBREW_PREFIX}/opt/zplug"
source $ZPLUG_HOME/init.zsh

if type brew &>/dev/null
then
  FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"
fi

# Starship for that fancy prompt
eval "$(starship init zsh)"

# Grab the aliases
source $ZDOTDIR/aliases.zsh

# Set vim mode
bindkey -v
export KEYTIMEOUT=1

# Reverse history search
bindkey '^R' history-incremental-search-pattern-backward
bindkey '^r' history-incremental-search-backward

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Make sure the completion menu pops up and is slim
setopt AUTO_MENU
setopt LIST_PACKED

# Set complation to case insensitve
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Add a fancy header to show what type a completion is
zstyle ':completion:*' format ' -- %d --'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands

# partial completion suggestions aka /u/l/b -> /usr/local/bin
zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix 

# append asdf completions to fpath
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

# Setup completions
autoload -Uz compinit && compinit

eval "$(op completion zsh)"; compdef _op op

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect '^xi' vi-insert

# dirstack hacks
setopt AUTO_CD            # Auto add cd command when a bare directory is typed
setopt AUTO_PUSHD         # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS  # Do not store duplicates in the stack.
setopt PUSHD_SILENT       # Do not print the directory stack after pushd or popd.
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

fortune_len="-s"
autoload zfortune && zfortune

# Source any local configs
test -e "${ZDOTDIR}/local.zsh" && source "${ZDOTDIR}/local.zsh"


# Add local bin
export PATH="$PATH:${HOME}/bin:$PATH"

# Set up homebrew
eval $(/opt/homebrew/bin/brew shellenv)

# Set up asdf
export ASDF_DATA_DIR="$XDG_CONFIG_HOME/asdf"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'; fi

# Set up History stuff
setopt HIST_SAVE_NO_DUPS   # Do not write a duplicate event to the history file.
setopt NO_CASE_GLOB        # Make all globs ignore case
#setopt SHARE_HISTORY       # share history across multiple zsh sessions
setopt APPEND_HISTORY      # append to history
#setopt INC_APPEND_HISTORY  # adds commands as they are typed, not at shell exit
setopt CORRECT             # Enable correction during commands

# Source atuin if it's installed
if type atuin &>/dev/null
then
  if [[ -f "${ZDOTDIR}/atuin.zsh" ]]; then
    source "${ZDOTDIR}/atuin.zsh"
  fi
  eval $(atuin init zsh)
fi
