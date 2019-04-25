# Init all shell variables and settings

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth
export HISTIGNORE='$:ls:[fb]g:exit:swd:w'
export HISTSIZE=2000
# append instead of overwriting history, and do it in realtime
shopt -s histappend
export PROMPT_COMMAND='history -a'
# add date / time to history entries
export HISTTIMEFORMAT='%b %d %H:%M '

export EDITOR=nvim
export GIT_EDITOR=nvim
export SVN_EDITOR=nvim

# Set pager to vim and alias less to it for good measure
if [[ -f /home/tavisto/src/github/lucc/nvimpager/nvimpager ]]
then
  export PAGER=/home/tavisto/src/github/lucc/nvimpager/nvimpager
else
  export PAGER=$HOME/bin/vimpager
fi
# Set the man page viewer to neovim
export MANPAGER="nvim '+set background=dark' '+set ft=man' -"
alias less=$PAGER
alias zless=$PAGER

# Set command line to vi mode and learn to deal with it :)
set -o vi
# ^l clear screen
bind -m vi-insert "\C-l":clear-screen

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Function definitions
if [ -f ~/.bash_functions ]; then
  . ~/.bash_functions
fi

my_time() {
  date +"%T"
}


# Set the default file permissions to 760
umask 026
export PATH=$HOME/bin:$PATH


USE_POWERLINE=false
if [[ `which powerline-go` ]]; then
  USE_POWERLINE=true
fi

function _update_ps1() {
  if [[ $USE_POWERLINE ]]; then
    PS1="$(powerline-go -modules time,aws,cwd,docker,dotenv,exit,jobs,ssh,termtitle,venv,vgo,git $?)"
  else
    PS1="\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
  fi
}

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PROMPT_COMMAND='_update_ps1; echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
  *)
    PROMPT_COMMAND='_update_ps1;'
    ;;
esac


###############################################################################
# OS specific settings
################################################################################

function load_darwin {
  export PLATFORM='darwin'
  # Fix screen
  alias ls='ls -G'
  alias screen="export SCREENPWD=$(pwd); /usr/bin/screen"

  if [ -f /usr/local/bin/hub ]; then
    alias git='hub'
  fi

  export BREW_PATH="/usr/local";
  if [ -d $BREW_PATH ]; then
    # Homebrew path
    prepend_path "$BREW_PATH/bin"
    prepend_path "$BREW_PATH/sbin"


    if [ -d "$BREW_PATH/opt/ruby" ]; then
      prepend_path "$BREW_PATH/opt/ruby/bin"
      export MANPATH=$BREW_PATH/opt/ruby/share/man:$MANPATH
    fi

    # Add homebrew path to the manpath
    export MANPATH=$BREW_PATH/share/man:$MANPATH
  fi


  # Only try and load the bash completion if it has not already been set.
  if [ -z $BASH_COMPLETION ]; then
    ## Enable programmable completion (if available)
    # Try from homebrew
    if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
      echo "Loading Bash Completions From Homebrew"
      . $(brew --prefix)/share/bash-completion/bash_completion
    fi
  else
    echo "No bash completion"
  fi
  . $HOME/.bash_completion
}

function load_linux
{
  # Only try and load the bash completion if it has not already been set.
  if [ -z $BASH_COMPLETION ];
  then
    #Bash completion settings
    if [ -f /etc/bash_completion ]; then
      BASH_COMPLETION="/etc/bash_completion"
      . /etc/bash_completion
    else
      echo "No bash completion."
    fi
  fi
  . $HOME/.bash_completion

  # Only try and load the bash completion directory if it has not already been set.
  if [ -z $BASH_COMPLETION_DIR ];
  then
    BASH_COMPLETION_DIR="/etc/bash_completion.d"
  fi

  bind "set completion-ignore-case on"
  echo Loaded Linux Settings
  export PLATFORM='linux'
  extend_path '/sbin'
  extend_path '/usr/sbin'
  extend_path '/usr/local/sbin'

  eval `/usr/bin/dircolors ~/.dircolors.ansi-dark`

  # enable color support of ls and also add handy aliases
  if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  fi

  if [[ -d /home/linuxbrew/.linuxbrew ]];
  then
    BREW_PATH=/home/linuxbrew/.linuxbrew
    prepend_path "$BREW_PATH/bin"
    prepend_path "$BREW_PATH/sbin"
  fi
}

# Load OS specific settings
case "`uname`" in
  'Darwin')
    load_darwin ;;
  'Linux')
    load_linux ;;
esac

bind "set completion-ignore-case on"

## Set up rbenv if installed
if [[ -d $HOME/.rbenv ]];
then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

## Set up pyenv if installed
if [[ -d $HOME/.pyenv ]];
then
  prepend_path "$HOME/.pyenv/bin"
  eval "$(pyenv init -)"
fi

# If go is installed setup the go path
if [[ `which go` ]];
then
  export GOPATH=$HOME/src/go
  extend_path $GOPATH/bin
fi

# If we have installed fzf source it!
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

################################################################################
# Local environment
################################################################################

# Load local configuration settings
if [ -f "$HOME/.bash_local" ]; then
  echo Loading local settings
  . "$HOME/.bash_local"
fi

################################################################################
#         Run tips at login
################################################################################
if [ -z $VIMRUNTIME ]; then
  tip
fi
