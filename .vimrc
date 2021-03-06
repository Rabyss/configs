filetype plugin on
filetype indent on
imap jk <Esc>
let mapleader=','
nnoremap <leader>s :up<enter>
set number
highlight LineNr ctermbg=Black ctermfg=Gray

set ruler
let g:tex_flavor='latex'
au BufNewFile,BufRead,BufWinEnter *.pxi,*.pyi setf python
autocmd FileType c,cpp,java,sh,python,javascript,matlab autocmd BufWritePre <buffer> :%s/\s\+$//e

set tabstop=2
set shiftwidth=2

" multiple tabs

map <C-t>w :tabr<cr>
map <C-t>s :tabl<cr>
map <C-t>a :tabp<cr>
map <C-t>d :tabn<cr>
