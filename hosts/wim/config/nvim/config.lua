vim.opt.fillchars = {eob = " "}
vim.cmd[[colorscheme dracula]]

-- https://github.com/AstroNvim/AstroNvim/issues/648#issuecomment-1511728897

vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0

-- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/983#issuecomment-1637372234


require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require('gitsigns').setup()
require('lualine').setup {
  options = {
    theme = 'dracula',
    globalstatus = true
  }
}
require("neo-tree").setup({
  close_if_last_window = true,
  enable_refresh_on_write = true,
  window = {
    width = 25,
  },
  filesystem = {
    use_libuv_file_watcher = true,
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = true,
      hide_by_name = {},
      hide_by_pattern = {},
      always_show = {},
      never_show = {},
      never_show_by_pattern = {},
    },
  },
  source_selector = {
    winbar = true,
    statusline = false
  },
  follow_current_file = {
    enabled = true,
    leave_dirs_open = true,
  }
})
require('todo-comments').setup()

-- Auto indent when pressing Enter between brackets
local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')
npairs.setup({map_cr=false})

_G.MUtils= {}

MUtils.completion_confirm=function()
    if vim.fn["coc#pum#visible"]() ~= 0  then
        return vim.fn["coc#pum#confirm"]()
    else
        return npairs.autopairs_cr()
    end
end

remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})

-- Indent Blanklines
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup { indent = { highlight = highlight } }

-- Autoclose Minimap
vim.api.nvim_create_autocmd('QuitPre', {
	pattern = '*',
	desc = 'Close minimap on exit',
	command = 'MinimapClose',
})
