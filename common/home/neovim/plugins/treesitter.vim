lua << EOF

local path = "/home/matt/.cache/nvim/"

require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
  indent = { enable = true },
  parser_install_dir = path,
  auto_install = true,
})

require('treesitter-context').setup({
  enable = true,
  max_lines = 3,
  min_window_height = 20,
})

vim.opt.runtimepath:append(path)
EOF

" Add line under context
hi TreesitterContextBottom gui=underline guisp=Grey
