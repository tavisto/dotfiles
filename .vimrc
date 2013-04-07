set nocompatible " Enable vim only features
" Pathogen setup
call pathogen#infect()
call pathogen#runtime_append_all_bundles()
"call pathogen#helptags()

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
set listchars=tab:▶-,eol:¬,trail:-

" Allow backspacing over everything
set backspace=indent,eol,start

" Insert mode completion options
set completeopt=menu,menuone,preview

" Remember up to 5000 'colon' commmands and search patterns
set history=5000

" do not put a cr at the end of the file. this will result in headers sent if you do web programming
set binary noeol

" Turn on syntax highlighting
syntax enable

" Set the background to dark
set background=dark

colorscheme solarized

" Make all tabs 4 spaces
" Make tabs delete properly
" Make autoindent add 4 spaces per indent level
set tabstop=4
set softtabstop=4
set shiftwidth=4
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

" set ruler " Always show current positions along the bottom
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [POS=%03l,%03v][%p%%]\ [LEN=%L]

" Always show status line, even for one window
set laststatus=2

" Explicitly tell Vim that the terminal supports 256 colors
set t_Co=256

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
"   Complete longest common string, then list alternatives.
set wildmode=longest,list,full

" Don't auto wrap anything
set textwidth=0
set linebreak " Wrap lines at convenient points

" Set the Grep program to my custom wcgrep
set grepprg=wcgrep

" Save undo into a folder only if supported
if exists('+undodir')
    set undodir=~/.vim/undodir
    set undofile
endif
if exists('+backupdir')
    set backupdir=~/.vim/backupdir
    set directory=~/.vim/backupdir
endif

" Set the column indecator to 80 columns
" If older vim then highlight in red after 80 columns
if exists('+colorcolumn')
    set colorcolumn=80
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Map %% to expand to the current working directory of the active buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" =============================================
" Plugin Configs
" =============================================

let g:syntastic_check_on_open=1
let g:syntastic_echo_current_error=1
let g:syntastic_enable_signs=1
let g:syntastic_enable_highlighting = 1
let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes': ['puppet','python','php'],
            \ 'passive_filetypes': [] }
let g:syntastic_python_checker = 'flake8'
let g:syntastic_puppet_lint_arguments = " --no-80chars-check "
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Make Gundo open on the right side
let g:gundo_right = 1

" Powerline stuff
let g:Powerline_symbols = 'fancy'
let g:Powerline_cache_enabled = 0
call Pl#Theme#InsertSegment('ws_marker', 'after', 'lineinfo')
if has("gui_running")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        set guifont=Source\ Code\ Pro\ Semibold:h16
    endif
endif

" =============================================
" Custon functions
" =============================================
function! LoadTags(tagfile)
    execute "set tags=~/.vim/tags/" . a:tagfile
endfunction

"
" Custon functions
"
function! LoadTags(tagfile)
    execute "set tags=~/.vim/tags/" . a:tagfile
endfunction

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
    let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
    if l:tabstop > 0
        let &l:sts = l:tabstop
        let &l:ts = l:tabstop
        let &l:sw = l:tabstop
    endif
    call SummarizeTabs()
endfunction

function! SummarizeTabs()
    try
        echohl ModeMsg
        echon 'tabstop='.&l:ts
        echon ' shiftwidth='.&l:sw
        echon ' softtabstop='.&l:sts
        if &l:et
            echon ' expandtab'
        else
            echon ' noexpandtab'
        endif
    finally
        echohl None
    endtry
endfunction

function! Preserve(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nmap <leader>$ :call Preserve("%s/\\s\\+$//e")<CR>
nmap <leader>= :call Preserve("normal gg=G")<CR>