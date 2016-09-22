filetype plugin on
filetype indent on
imap jj <Esc>
let mapleader=','
nnoremap <leader>s :up<enter>
set number
highlight LineNr ctermbg=Black ctermfg=Gray

set ruler
let g:tex_flavor='latex'
au BufNewFile,BufRead,BufWinEnter *.pxi,*.pyi setf python
autocmd FileType c,cpp,java,sh,python,javascript,matlab autocmd BufWritePre <buffer> :%s/\s\+$//e

