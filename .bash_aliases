#!/bin/bash
# .bash_aliases

alias swd='pushd +1 ; dirs -v'
alias dirs='dirs -v'
alias grep='grep --color'

alias :q='exit'

alias ll='ls -lart'
alias la='ls -A'

alias vi='echo "Use vim, You will thank me in the end" '

alias hgroot='pushd `hg root`'
alias gitroot='pushd `git root`'
alias dhog='du -cks * | sort -rn'

alias apcclear='curl http://localhost/meta/api/apc/clear &> /dev/null || echo "APC clear failed."'
alias bpupdate='sudo yum update bpapp*'
alias consume_status='sudo supervisorctl status | column -t'
alias tree='tree -C'
alias mkdatedir='mkdir `date "+%Y-%m-%d"`'
alias queueinfo='ansible intqueue -Ks -a "/home/taitken/bin/queueinfo.sh delivery"'
alias stagequeueinfo='ansible intqueuestage -Ks -a "/home/taitken/bin/queueinfo.sh delivery"'
