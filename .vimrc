" Dnable loading filetype and indentation plugins
filetype plugin on
filetype indent on

" Show Whitespace
" highlight WhiteSpaceEOL ctermbg=darkgreen guibg=lightgreen
" match WhiteSpaceEOL /^\s*\ \s*\|\s\+$/
" autocmd WinEnter * match WhiteSpaceEOL /^\s*\ \s*\|\s\+$/
set listchars=tab:>-,trail:-

" Allow backspacing over everything
set backspace=indent,eol,start

" Insert mode completion options
set completeopt=menu,menuone,preview

" Remember up to 500 'colon' commmands and search patterns
set history=500

" do not put a cr at the end of the file. this will result in headers sent if you do web programming
set binary noeol

syntax on
set nocp " Enable vim only features
set backspace=2
set ch=2 " Make command line two lines high
set tabstop=4 " Make all tabs 4 spaces
set shiftwidth=4 " Make autoindent add 4 spaces per indent level
set expandtab
set encoding=utf-8 " Allow editing of utf-8 files.
set iskeyword+=_,$,@,%,#,- " Adds things to the keyword search

" When a bracket is inserted, briefly jump to a matching one
set showmatch
set matchtime=3 " Match brackets for 3/10th of a sec.

set autoindent " Auto Indent
set smartindent " Smart Indent
set mouse=n " Mouse in normal mode
set ignorecase
set smartcase

set nohlsearch " Don't Highlight searches 

set ruler " Always show current positions along the bottom
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [POS=%03l,%03v][%p%%]\ [LEN=%L]

" Always show status line, even for one window
set laststatus=2

" Scroll when cursor gets within 3 characters of top/bottom edge
set scrolloff=3
set scrolljump=5 " Set the scroll jump to be 5 lines

" Show (partial) commands (or size of selection in Visual mode) in the status line
set showcmd

" Enable CTRL-A/CTRL-X to work on octal and hex numbers, as well as characters
set nrformats=octal,hex,alpha

" Remember things between sessions
"
" '20  - remember marks for 20 previous files
" \"50 - save 50 lines for each register
" :20  - remember 20 items in command-line history
" %    - remember the buffer list (if vim started without a file arg)
" n    - set name of viminfo file
set viminfo='20,\"50,:20,%,n~/.viminfo

" Use menu to show command-line completion (in 'full' case)
set wildmenu

" Set command-line completion mode:
"   - on first <Tab>, when more than one match, list all matches and complete
"     the first string
"   - on second <Tab>, complete the next full match and show menu
set wildmode=list,full


" Start wrapping at 100 columns
set textwidth=0

"
" Key Mappings
"

" switch to upper/lower window quickly
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" use CTRL-F for omni completion
imap <C-F> 

" Toggle search highlight
nmap <silent> <F2> :NERDTreeToggle<CR>

" Toggle search highlight
nmap <silent> <F3> :set hls!<CR>

" Remove all windows line endings
"nmap <silent> <F4> :%s/\r//g<CR>
" Rerun last : command
"nmap <silent> <F4> @:<CR>

" use <F5> to add phpdoc tags.
nmap <silent> <F4> :call PhpDoc()<CR>

" Use <F5> to togle comments  
nmap <silent> <F5> ,ci<CR>


" use <F6> to toggle line numbers
nmap <silent> <F6> :set number!<CR>

" use <F7> to togle folding
nmap <silent> <F7> za

" <F8> Used for Taglist

" Togle showing non printing chars 
nmap <silent> <F9> :set list!<CR>

" Execute SQL visually selected
" mnemonic sql - execute
vnoremap E :DBExecVisualSQL <CR>

let  g:dbext_default_history_file = '~/.vim/dbext_sql_history.sql'

set grepprg=grep

"
" Custon functions
"

function! LoadTags(tagfile)
	execute "set tags=~/.vim/tags/" . a:tagfile
endfunction

fu! Dupdd()
	execute ":%s/[ ^I]*$"
	execute ":%!sed '/./,/^$/ \\!d'"
endfunction

fu! ConnectDb(dbname)
    execute ":DBSetOption type=MySQL:host=@ask:dbname=" . a:dbname . ":user=@ask:passwd=@ask"
endfunction

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