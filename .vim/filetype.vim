"
" Filetype detection
"
augroup filetypedetect
    " Detect .txt as 'text'
    autocmd! BufNewFile,BufRead *.txt setfiletype text
    " PHP
    autocmd! BufNewFile,BufRead *.phtml setfiletype php 
    " Svn commmits
    au BufNewFile,BufRead  svn-commit.* setf svn
    " Actionscript 
    au BufNewFile,BufRead *.as setf actionscript 
    " ini files as well as .hgrc files
    au BufNewFile,BufRead *.ini,*/.hgrc,*/.hg/hgrc setf ini
    "Json files
    au BufNewFile,BufRead *.json setf json

    au BufNewFile,BufRead *puppet* setf puppet 
    autocmd FileType python compiler pylint

    au! BufRead,BufNewFile /var/log/syslog/*  set filetype=syslog 
    au! BufRead,BufNewFile bp*.log  set filetype=pythonlog
    au! BufRead,BufNewFile *.log  set filetype=syslog
augroup END

