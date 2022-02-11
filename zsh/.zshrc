#!/usr/bin/env zsh

setopt HIST_SAVE_NO_DUPS   # Do not write a duplicate event to the history file.
setopt NO_CASE_GLOB        # Make all globs ignore case
setopt SHARE_HISTORY       # share history across multiple zsh sessions
setopt APPEND_HISTORY      # append to history
setopt INC_APPEND_HISTORY  # adds commands as they are typed, not at shell exit
setopt CORRECT             # Enable correction during commands

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
