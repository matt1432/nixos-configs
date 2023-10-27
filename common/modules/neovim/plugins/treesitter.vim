lua << EOF

require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
  indent = { enable = true }
})

require('treesitter-context').setup({
  enable = true,
  max_lines = 3,
  min_window_height = 20,
})

EOF

" Add line under context
hi TreesitterContextBottom gui=underline guisp=Grey
