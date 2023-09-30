" make tabs only 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent

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

nnoremap <silent> <esc> :noh<cr><esc>

let g:minimap_width = 10
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1
let g:minimap_git_colors = 1
