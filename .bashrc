# Init all shell variables and settings

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
export HISTIGNORE='$:ls:[fb]g:exit:swd:w'
export HISTSIZE=2000

export EDITOR=vim
#export PAGER=$HOME/bin/less.sh
export PAGER=less
export GIT_EDITOR=vim
export SVN_EDITOR=vim

PINK=$'\e[35;40m'
GREEN=$'\e[32;40m'
ORANGE=$'\e[33;40m'


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
#VC_PS1= ~/bin/vcprompt -f "%b:${PINK}%r ${ORANGE}%u"
# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
    #xterm*|screen*)
    #PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;34m\]@\[\033[37m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]${VC_PS1}\$ "
    #;;
    #*)
    #PS1='${debian_chroot:+($debian_chroot)}\u-\h:\W\$ '
    #;;
#esac


vc_ps1() {
    PINK=$'\e[35;40m'
    GREEN=$'\e[32;40m'
    ORANGE=$'\e[33;40m'
    BLUE=$'\e[34;40m'
    RED=$'\e[31;40m'
    WHITE=$'\e[37;40m'
        ~/bin/vcprompt -f "${GREEN}(${BLUE}%s:${WHITE}%b${PINK}%i${GREEN})" 2>/dev/null
        #FORMAT (default="[%n:%b%m%u] ") may contain:
         #%b  show branch
         #%r  show revision
         #%s  show VC name
         #%%  show '%'
    }

vc_ps1_nocolor() { 
    ~/bin/vcprompt -f "(%s:%b:%i)" 2>/dev/null
    }

if [ -z $VIMRUNTIME ]; then
    . ~/.bash_color
    export PS1="${RED}[${BRIGHT_GREEN}\u${BLUE}@${WHITE}\h${BLUE}:${GREEN}\w${RED}]\$(vc_ps1)${NORMAL}\n$ "
else
    export PS1="[\w]\$(vc_ps1_nocolor)\n$ "
fi

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
function prepend_path {
  if [[ $PATH != *:$1* ]]; then
    export PATH="$1:$PATH"
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

extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2) tar xvjf "$1" ;;
            *.tar.gz)  tar xvzf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar x "$1" ;;
            *.rpm)     rpm2cpio "$1" | cpio -idmv ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xvf "$1" ;;
            *.tbz2)    tar xvjf "$1" ;;
            *.tgz)     tar xvzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

###############################################################################
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
        elif [ -f /usr/local/etc/bash_completion ]; then
            . /usr/local/etc/bash_completion
        elif [ -f /sw/etc/bash_completion ]; then
            . /sw/etc/bash_completion
        elif [ -f ~/homebrew/etc/bash_completion ]; then
            . ~/homebrew/etc/bash_completion 
        else 
            echo "No bash completion."
        fi
    fi
    . $HOME/.bash_completion

    # Only try and load the bash completion directory if it has not already been set.
    if [ -z $BASH_COMPLETION_DIR ];
    then
        if [ -d /opt/local/etc/bash_completion.d ]; then
            BASH_COMPLETION_DIR="/opt/local/etc//bash_completion.d"
        elif [ -d /usr/local/etc/bash_completion.d ]; then
            BASH_COMPLETION_DIR="/usr/local/etc//bash_completion.d"
        elif [ -d /sw/etc/bash_completion.d ]; then
            BASH_COMPLETION_DIR="/sw/etc//bash_completion.d"
        elif [ -d ~/homebrew/etc/bash_completion.d ]; then
            BASH_COMPLETION_DIR="~/homebrew/etc//bash_completion.d"
        else 
            echo "No bash completion."
        fi
    fi

	# Setup Java
	#export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home"

    # MacPorts path
    extend_path '/opt/local/bin';
    extend_path '/opt/local/sbin';
    # Homebrew path
    extend_path $HOME'/homebrew/sbin';
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
	alias ls='ls --color=auto'
	export PLATFORM='linux'
	extend_path '/sbin'
	extend_path '/usr/sbin'
	extend_path '/usr/local/sbin'
}


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
if [ -z $VIMRUNTIME ]; then
    tip
fi
