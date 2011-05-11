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
    autocmd BufNewFile,BufRead *.as set filetype=actionscript 
    autocmd BufNewFile,BufRead *.mxml set filetype=mxml 

    au! BufRead,BufNewFile /var/log/syslog/*  set filetype=syslog
    au! BufRead,BufNewFile *.log  set filetype=syslog
    au! BufRead,BufNewFile bp*.log  set filetype=pythonlog
    au! BufRead,BufNewFile supervisord.conf set filetype=ini
augroup END
augroup Binary
    au!
    au BufReadPre  *.bin,*.jpg,*.mp3,*.wav let &bin=1
    au BufReadPost *.bin,*.jpg,*.mp3,*.wav if &bin | %!xxd 
    au BufReadPost *.bin,*.jpg,*.mp3,*.wav set ft=xxd | endif
    au BufWritePre *.bin,*.jpg,*.mp3,*.wav if &bin | %!xxd -r
    au BufWritePre *.bin,*.jpg,*.mp3,*.wav endif
    au BufWritePost *.bin,*.jpg,*.mp3,*.wav if &bin | %!xxd
    au BufWritePost *.bin,*.jpg,*.mp3,*.wav set nomod | endif
augroup END
