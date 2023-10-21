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
autocmd Filetype coffeescript setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype jade setlocal ts=4 sw=4 sts=0 expandtab

set number
set relativenumber

set undofile
set undodir=/home/matt/.cache/nvim/

" set dot icon in place of trailing whitespaces
set list listchars=tab:\ \ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨

" use vscode keybinds for snippets completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" support scss @
autocmd FileType scss setl iskeyword+=@-@

" remove highlight on words
nnoremap <silent> <esc> :noh<cr><esc>

" Minimap config
let g:minimap_width = 6
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1
let g:minimap_git_colors = 1

" Auto open Neo-Tree on big enough window
function! OpenTree() abort
  if &columns > 100
    Neotree show
    Neotree close
    Neotree show
  endif
endfunction

autocmd VimEnter * call OpenTree()
