"
" Key Mappings
"


" switch to upper/lower window quickly
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" F1 reserved for help

" Show error window from synstastic
nmap <silent> <S-F1> :Errors<CR>

" Toggle NERDTree 
nmap <silent> <F2> :NERDTreeToggle<CR>
nmap <silent> <S-F2> :NERDTreeFind<CR>

" Toggle search highlight
nmap <silent> <F3> :set hls!<CR>

" Rerun last : command
nmap <silent> <F4> :GundoToggle<CR>

" Use <F5> to togle comments 
nmap <silent> <F5> <Plug>NERDCommenterToggle

" use <F6> to toggle line numbers
nmap <silent> <F6> :set number!<CR>
nmap <silent> <S-F6> :set relativenumber!<CR>

" use <F7> to togle folding
nmap <silent> <F7> za

" map <F8> to toggle taglist window
" nmap <silent> <F8> :TlistToggle<CR>
" Set in .vim/after/plugin/general.vim only if taglist can be run

" Togle showing non printing chars
nmap <silent> <F9> :set list!<CR>

" Togle paste mode on and off with F10
set pastetoggle=<F10>

" Add current buffer to diff
nmap <silent> <F11> :diffthis<CR>

" Check current file with synstastic
nmap <silent> <F12> :SyntasticCheck<CR>

" Use <S-F12> for filetype specific functions
" PHP:
" nmap <S-F12> <silent> :call PhpDoc()
" Python:
" nmap <S-F12> spep8 on python filetype
let g:pep8_map='<S-F12>'

" Map <leader>mc to count the number of matches the curren search will
" return in the current buffer
nmap <silent> <leader>mc :%s///gn<CR>

" Fix the & command to always preserve flags on searches 
" in both normal and visual mode
nnoremap & :&&<CR>
xnoremap & :&&<CR>
