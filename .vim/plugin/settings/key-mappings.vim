"
" Key Mappings
"


" switch to upper/lower window quickly
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Toggle NERDTree 
nmap <silent> <F2> :NERDTreeToggle<CR>

" Toggle search highlight
nmap <silent> <F3> :set hls!<CR>

" Rerun last : command
nmap <silent> <F4> @:<CR>

" Use <F5> to togle comments 
nmap <silent> <F5> <Plug>NERDCommenterToggle

" use <F6> to toggle line numbers
nmap <silent> <F6> :set number!<CR>

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

" Use <F12> for filetype specific functions
" PHP:
" nmap <F12> <silent> :call PhpDoc()
" Python:
" nmap <F12> spep8 on python filetype
