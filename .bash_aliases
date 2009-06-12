# .bash_aliases

alias up2='cd ../..';
alias up3='cd ../../..';
alias up4='cd ../../../..';

alias swd='pushd +1 ; dirs -v'
alias dirs='dirs -v'
alias grep='grep --color'

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias svn?="svn st -u | grep '^\?' | awk '{print $2}'"

alias config='git --git-dir=$HOME/Documents/Dropbox/Dropbox/git/settings/.git/ --work-tree=$HOME/'
alias config-st='config status'
alias config-add-f='config add -f'
