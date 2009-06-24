# .bash_profile

# Get the aliases and functions
#if [ -f ~/.bashrc ]; then
	#. ~/.bashrc
#fi

# Get the local config options
if [ -f ~/.local_config/.bash_local ]; then
	. ~/.local_config/.bash_local
fi

# User specific environment and startup programs

umask 022
export HISTIGNORE='$:ls:[fb]g:exit:swd:w'

export EDITOR=vim
export GIT_EDITOR=vim
export SVN_EDITOR=vim
# Set command line to vi mode and learn to deal with it :) 
set -o vi
# ^l clear screen
bind -m vi-insert "\C-l":clear-screen

PATH=$HOME/bin/:$HOME/local/bin:$HOME/source_code/:$PATH

export PATH
unset USERNAME


function random_line 
{
	LINES=$( wc -l "$1" | awk '{ print ($1 +1) }' )
	RANDSEED=$( date '+%S%M%I' )
	LINE=$( cat "$1" | awk -v "COUNT=$LINES" -v "SEED=$RANDSEED" 'BEGIN { srand(SEED);i=int(rand()*COUNT) } FNR==i { print $0 }');
	echo "$LINE"
}

function tip 
{
	echo `random_line "$HOME/.tips"`
}

#-------------------------------------#
#         Run tips at login           #
#-------------------------------------#
tip
