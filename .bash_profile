# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

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

PATH=$HOME/bin/:$HOME/local/bin:$HOME/source_code/:$PATH

export PATH
unset USERNAME

