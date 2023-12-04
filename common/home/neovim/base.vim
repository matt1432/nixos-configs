" by default, the indent is 2 spaces.
set smartindent
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" for html/rb files, 2 spaces
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab

" for js/coffee/jade files, 4 spaces
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype java setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype sh setlocal ts=4 sw=4 sts=0 expandtab

" support scss @
autocmd FileType scss setl iskeyword+=@-@

set number
set relativenumber

set undofile
set undodir=/home/matt/.cache/nvim/

" remove highlight on words
nnoremap <silent> <esc> :noh<cr><esc>
