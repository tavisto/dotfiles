# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

umask 022
export HISTIGNORE='$:ls:[fb]g:exit:swd:w'

export EDITOR=vim

PATH=$HOME/bin:$HOME/local/bin:$HOME/source_code/:$PATH

export PATH
unset USERNAME

