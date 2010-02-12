# Init all shell variables and settings

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
export HISTIGNORE='$:ls:[fb]g:exit:swd:w'

export EDITOR=vim
#export PAGER=$HOME/bin/less.sh
export PAGER=less
export GIT_EDITOR=vim
export SVN_EDITOR=vim

# Set command line to vi mode and learn to deal with it :) 
set -o vi
# ^l clear screen
bind -m vi-insert "\C-l":clear-screen

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm*|screen*)
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;34m\]@\[\033[37m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
	;;
	*)
	PS1='${debian_chroot:+($debian_chroot)}\u-\h:\W\$ '
	;;
esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
	PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
	;;
	*)
	;;
esac

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi



umask 022
export PATH=$HOME/bin/:$HOME/local/bin:$HOME/source_code/:$PATH

################################################################################
# Functions 
################################################################################
function random_line 
{
	LINES=$( wc -l "$1" | awk '{ print ($1 +1) }' )
	RANDSEED=$( date '+%S%M%I' )
	LINE=$( cat "$1" | awk -v "COUNT=$LINES" -v "SEED=$RANDSEED" 'BEGIN { srand(SEED);i=int(rand()*COUNT) } FNR==i { print $0 }');
	echo "$LINE"
}

function extend_path {
  if [[ $PATH != *:$1* ]]; then
    export PATH="$PATH:$1"
  fi
}

function command_exists {
  if command -v "$1" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

function tip 
{
	echo `random_line "$HOME/.tips"`
}

################################################################################
# OS specific settings
################################################################################

function load_darwin {
	export PLATFORM='darwin'
	# Fix screen
	alias ls='ls -G'
	alias screen="export SCREENPWD=$(pwd); /usr/bin/screen"
	export SHELL="/bin/bash -rcfile $HOME/.bash_profile"

	# Switch to current working directory when screen is started
	if [[ "$TERM" == 'screen' ]]; then
		cd "$SCREENPWD"
	fi

	# Load Fink on OS X
	if [[ -x /sw/bin/init.sh ]]; then
		/sw/bin/init.sh
	fi

    # Only try and load the bash completion if it has not already been set.
    if [ -z $BASH_COMPLETION ];
    then
        ## Enable programmable completion (if available)
        if [ -f /opt/local/etc/bash_completion ]; then
            . /opt/local/etc/bash_completion
        elif [ -f /sw/etc/bash_completion ]; then
            . /sw/etc/bash_completion
        elif [ -f ~/homebrew/etc/bash_completion ]; then
            . ~/homebrew/etc/bash_completion 
        else 
            echo "No bash completion."
        fi
    fi

	# Setup Java
	#export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home"
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
	bind "set completion-ignore-case on"
    echo Loaded Linux Settings
	alias ls='ls --color=auto'
	export PLATFORM='linux'
	extend_path '/sbin'
	extend_path '/usr/sbin'
	extend_path '/usr/local/sbin'
}

# Only try and load the bash completion directory if it has not already been set.
if [ -z $BASH_COMPLETION_DIR ];
then
    BASH_COMPLETION_DIR="$HOME/.bash_completion.d"
fi


# Load OS specific settings
case "`uname`" in
	'Darwin')
	load_darwin ;;
	'Linux')
	load_linux ;;
esac

bind "set completion-ignore-case on"

if [ `type -P git` ];then
## enable colours for git 
   git config --global color.diff auto
   git config --global color.status auto
   git config --global color.branch auto
fi
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
tip
