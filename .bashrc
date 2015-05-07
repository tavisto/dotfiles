# Init all shell variables and settings

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
export HISTIGNORE='$:ls:[fb]g:exit:swd:w'
export HISTSIZE=2000
# append instead of overwriting history, and do it in realtime
shopt -s histappend
export PROMPT_COMMAND='history -a'
# add date / time to history entries
export HISTTIMEFORMAT='%b %d %H:%M '

export EDITOR=vim
export GIT_EDITOR=vim
export SVN_EDITOR=vim

# Set pager to vim and alias less to it for good measure
export PAGER=$HOME/bin/vimpager
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
vc_ps1() {
        # Define colors
        PINK=$'\e[35;40m'
        GREEN=$'\e[32;40m'
        ORANGE=$'\e[33;40m'
        BLUE=$'\e[34;40m'
        RED=$'\e[31;40m'
        WHITE=$'\e[37;40m'
        ~/bin/vcprompt -f "${GREEN}(${BLUE}%s: ${WHITE}%b ${ORANGE}%r ${PINK}%i${GREEN})" 2>/dev/null
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
    export PS1="${RED}[${BRIGHT_GREEN}\$(my_time) \u${BLUE}@${WHITE}\h${BLUE}:${GREEN}\w${RED}]\$(vc_ps1)${NORMAL}\n$ "
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

# Set the default file permissions to 760
umask 026
export PATH=$HOME/bin:$PATH

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
    alias ls='ls --color=auto'
    export PLATFORM='linux'
    extend_path '/sbin'
    extend_path '/usr/sbin'
    extend_path '/usr/local/sbin'

    eval `/usr/bin/dircolors ~/.dircolors.ansi-dark`
}

# Load OS specific settings
case "`uname`" in
    'Darwin')
    load_darwin ;;
    'Linux')
    load_linux ;;
esac

bind "set completion-ignore-case on"

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
