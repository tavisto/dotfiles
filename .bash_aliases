# .bash_aliases

alias swd='pushd +1 ; dirs -v'
alias dirs='dirs -v'
alias grep='grep --color'

alias :q='exit'

alias ll='ls -lart'
alias la='ls -A'

alias vi='echo "Use vim, You will thank me in the end" '

alias hgroot='cd `hg root`'
alias dhog='du -cks * | sort -rn'

alias apcclear='curl http://localhost/meta/api/apc/clear &> /dev/null || echo "APC clear failed."'
alias bpupdate='sudo yum makecache && sudo yum update bpapp*'
alias phpunit='php /usr/share/php/PHPUnit/phpunit.php --colors'
alias consume_status='sudo supervisorctl status | column -t'
