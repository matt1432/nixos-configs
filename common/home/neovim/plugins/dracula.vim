" set dot icon in place of trailing whitespaces
set list listchars=tab:\ \ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨


lua << EOF
-- Add visual indicator for trailing whitespaces
vim.opt.fillchars = {eob = " "}

vim.cmd[[colorscheme dracula]]
EOF
