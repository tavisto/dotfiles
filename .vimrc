set nocompatible " Enable vim only features
" Pathogen setup 
call pathogen#infect()
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Enable loading filetype and indentation plugins
filetype plugin on
filetype indent on

set autoread " Reload files that have changed outside of vim

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

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

" Turn on syntax highlighting
syntax enable
" Set the background to dark
set background=dark

colorscheme solarized

set backspace=2
set ch=2 " Make command line two lines high

set tabstop=4 " Make all tabs 4 spaces
set softtabstop=4 " Make tabs delete properly
set shiftwidth=4 " Make autoindent add 4 spaces per indent level
set expandtab " Convert all tabs
set smarttab

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

" Set the default behavior of opening a buffer to use the one already open
set swb=useopen

" Use menu to show command-line completion (in 'full' case)
set wildmenu

" Set command-line completion mode:
"   - on first <Tab>, when more than one match, list all matches and complete
"     the first string
"   - on second <Tab>, complete the next full match and show menu
set wildmode=list,full

" Start wrapping at 100 columns
set textwidth=0
set linebreak " Wrap lines at convenient points

" Set the Grep program to my custom wcgrep
set grepprg=wcgrep

autocmd FileType yaml set ts=2

" Change leader to a comma for ease of use
let mapleader=","

let g:syntastic_check_on_open=1
let g:syntastic_echo_current_error=1
let g:syntastic_enable_signs=1
let g:syntastic_enable_highlighting = 1
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [
'xml', 'html', 'puppet', 'python', 'php'],
                           \ 'passive_filetypes': ['ruby'] }
let g:syntastic_python_checker = 'pylint'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Save undo into a folder
set undodir=~/.vim/undodir
set undofile

"
" Custon functions
"
function! LoadTags(tagfile)
    execute "set tags=~/.vim/tags/" . a:tagfile
endfunction

" Set the column indecator to 80 columns
" If older vim then highlight in red after 80 columns
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif