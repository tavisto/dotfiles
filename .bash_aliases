# .bash_aliases

alias up2='cd ../..';
alias up3='cd ../../..';
alias up4='cd ../../../..';

alias swd='pushd +1 ; dirs -v'
alias dirs='dirs -v'
alias grep='grep --color'

alias :q='exit'

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias svn?="svn st -u | grep '^\?' | awk '{print $2}'"
alias svnadd?="svn st -u | grep '^\?' | awk '{print $2}' | xargs svn add"

alias vless='~/bin/less.sh'

alias vi='echo "Use vim, You will thank me in the end" '
