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

alias tree='tree -Cp'
alias gpush='git pull --rebase && git push'
alias mkdatedir='mkdir `date "+%Y-%m-%d"`'
alias tophistory='history | awk '"'"'{ print $5 }'"'"' | sort | uniq -c | sort -rn | head -25'
alias pkglist='grep "el." | sort | uniq -c'
alias rockeval='eval $(rock env)'
