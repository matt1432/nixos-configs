" Auto open Neo-Tree on big enough window
function! OpenTree() abort
  if &columns > 100
    Neotree show
    Neotree close
    Neotree show
  endif
endfunction

autocmd VimEnter * call OpenTree()
