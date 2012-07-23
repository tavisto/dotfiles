"
" Settings for PHP filetype
"

function! Zendify()
     silent! execute ':%s/( /(/g'
     silent! execute ':%s/ )/)/g'
     silent! execute ':%s/ \]/\]/g'
     silent! execute ':%s/\[ /\[/g'
     silent! execute ':%s/\s*,\s*/, /'
     silent! execute ':%s/if(/if (/'
     silent! execute ':%s/if(/if (/'
     silent! execute ':%s/foreach(/foreach (/'
     silent! execute ':%s/foreach(/foreach (/'
     silent! execute ':%s/while(/while (/'
     silent! execute ':%s/catch(/catch (/'
     silent! execute ':%s/\(foreach\|if\|while\|catch\)\s*\(.*\)\s*\n\s*{/\1 \2 {/'
     silent! execute ':%s/\s*\(try\|else\)\s*\s*\n*\s*\({\)/\1 \2/'
     silent! execute ':%s/\(}\)\s*\n*\s*\(else\)/\1 \2/'
     silent! execute ':%s/\t/    /g'
     silent! execute ':%s/\s*$//g'
endfunction

" Load PHP Documentor for VIM
source ~/.vim/bundle/phpdoc/plugin/php-doc.vim
nmap <silent> <F12> :call PhpDoc()<CR>


" Set up automatic formatting
set formatoptions+=tcqlro

"
" Syntax options
"
" Enable folding of class/function blocks
let php_folding = 0

" Do not use short tags to find PHP blocks
let php_noShortTags = 1

" Highlighti SQL inside PHP strings
let php_sql_query=1

"
" Linting
"
" Use PHP syntax check when doing :make
set makeprg=php\ -l\ %

" Parse PHP error output
set errorformat=%m\ in\ %f\ on\ line\ %l

" Function to locate endpoints of a PHP block {{{
function! PhpBlockSelect(mode)
	let motion = "v"
	let line = getline(".")
	let pos = col(".")-1
	let end = col("$")-1

	if a:mode == 1
		if line[pos] == '?' && pos+1 < end && line[pos+1] == '>'
			let motion .= "l"
		elseif line[pos] == '>' && pos > 1 && line[pos-1] == '?'
			" do nothing
		else
			let motion .= "/?>/e\<CR>"
		endif
		let motion .= "o"
		if end > 0
			let motion .= "l"
		endif
		let motion .= "?<\\?php\\>\<CR>"
	else
		if line[pos] == '?' && pos+1 < end && line[pos+1] == '>'
			" do nothing
		elseif line[pos] == '>' && pos > 1 && line[pos-1] == '?'
			let motion .= "h?\\S\<CR>""
		else
			let motion .= "/?>/;?\\S\<CR>"
		endif
		let motion .= "o?<\\?php\\>\<CR>4l/\\S\<CR>"
	endif

	return motion
endfunction
" }}}

" Mappings to select full/inner PHP block
nmap <silent> <expr> vaP PhpBlockSelect(1)
nmap <silent> <expr> viP PhpBlockSelect(0)
" Mappings for operator mode to work on full/inner PHP block
omap <silent> aP :silent normal vaP<CR>
omap <silent> iP :silent normal viP<CR>

" Mappings for PHP Documentor for VIM
inoremap <buffer> <C-P> <Esc>:call PhpDocSingle()<CR>i
nnoremap <buffer> <C-P> :call PhpDocSingle()<CR>
vnoremap <buffer> <C-P> :call PhpDocRange()<CR>
" Generate @uses tag based on inheritance info
let g:pdv_cfg_Uses = 1
" Set default Copyright
let g:pdv_cfg_Copyright = "Copyright (C) 2009 Beatport LLC "

" Exuberant Ctags
"
" Map <F4> to re-build tags file
"nmap <silent> <F4>
"		\ :!ctags-ex -f ./tags 
"		\ --langmap="php:+.inc"
"		\ -h ".php.inc" -R --totals=yes
"		\ --tag-relative=yes --PHP-kinds=+cf-v .<CR>

" Set tag filename(s)
" set tags=./tags,tags

" vim: set fdm=marker:
