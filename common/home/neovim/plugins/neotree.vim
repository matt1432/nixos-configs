" Auto open Neo-Tree on big enough window
function! OpenTree() abort
  if &columns > 100
    Neotree show
    Neotree close
    Neotree show
  endif
  lua MiniMap.open()
endfunction

autocmd VimEnter * call OpenTree()
