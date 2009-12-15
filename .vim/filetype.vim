"
" Filetype detection
"
augroup filetypedetect
	" Detect .txt as 'text'
    autocmd! BufNewFile,BufRead *.txt setfiletype text
augroup END

au BufNewFile,BufRead  svn-commit.* setf svn
" Actionscript 
au BufNewFile,BufRead *.as		setf actionscript 

au BufNewFile,BufRead *.ini,*/.hgrc,*/.hg/hgrc setf ini
