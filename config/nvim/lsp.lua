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
  window = {
    width = 30,
  },
  filesystem = {
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = false,
      hide_gitignored = true,
      hide_by_name = {},
      hide_by_pattern = {},
      always_show = {},
      never_show = {},
      never_show_by_pattern = {},
    },
  },
  follow_current_file = {
    enabled = true,
    leave_dirs_open = true,
  }
})
require('todo-comments').setup()
require("scrollbar").setup()

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
