#!/usr/bin/env zsh


setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.

# Set up homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Setup zplug
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi


# Starship for that fancy prompt
eval "$(starship init zsh)"

# Grab the aliases
source $ZDOTDIR/aliases.zsh

# Set vim mode
bindkey -v
export KEYTIMEOUT=1

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Setup completions
autoload -U compinit; compinit
_comp_options+=(globdots) # With hidden files

# Set complation to case insensitve
setopt MENU_COMPLETE
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

# Reverse history search
bindkey '^R' history-incremental-search-pattern-backward
bindkey '^r' history-incremental-search-backward

# dirstack hacks
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index # directory stack

# Pyenv
eval "$(pyenv init --path)"

test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && source "${ZDOTDIR}/.iterm2_shell_integration.zsh"

FPATH="${ZDOTDIR}:${FPATH}"
fortune_len="-s"
autoload zfortune && zfortune
