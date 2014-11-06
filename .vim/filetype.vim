"
" Filetype detection
"
augroup filetypedetect

    " Detect .tt as 'twig' type template
    autocmd! BufNewFile,BufRead *.tt setfiletype twig

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

    " VCL for varnish configs
    au BufRead,BufNewFile *.vcl setf vcl

    " Puppet files
    "au BufNewFile,BufRead *puppet* setf puppet
    au BufNewFile,BufRead *.pp setf puppet

    " Set vagrant files as ruby
    au BufNewFile,BufRead Vagrantfile setf ruby

    au! BufRead,BufNewFile /var/log/*  set filetype=syslog
    au! BufRead,BufNewFile *.log  set filetype=syslog
    au! BufRead,BufNewFile */nginx/* set ft=nginx
    au! BufRead,BufNewFile *.fdoc* set ft=yaml
augroup END
augroup Binary
      au!
      au BufReadPre   *.bin,*.jpg,*.mp3,*.wav,*.aif,*.mp4 let &bin=1
      au BufReadPost  *.bin,*.jpg,*.mp3,*.wav,*.aif,*.mp4 if &bin | %!xxd -c 32
      au BufReadPost  *.bin,*.jpg,*.mp3,*.wav,*.aif,*.mp4 set ft=xxd | endif
      au BufWritePre  *.bin,*.jpg,*.mp3,*.wav,*.aif,*.mp4 if &bin | %!xxd -r
      au BufWritePre  *.bin,*.jpg,*.mp3,*.wav,*.aif,*.mp4 endif
      au BufWritePost *.bin,*.jpg,*.mp3,*.wav,*.aif,*.mp4 if &bin | %!xxd
      au BufWritePost *.bin,*.jpg,*.mp3,*.wav,*.aif,*.mp4 set nomod | endif
augroup END
