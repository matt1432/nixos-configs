local map = require('mini.map')
map.setup({
  integrations = {
    map.gen_integration.builtin_search(),
    map.gen_integration.gitsigns(),
    map.gen_integration.diagnostic(),
  },
  window = {
    focusable = true,
    width = 7,
    winblend = 75,
  },
})

local ts_input = require('mini.surround').gen_spec.input.treesitter
require('mini.surround').setup({
  custom_surroundings = {
    -- Use tree-sitter to search for function call
    f = {
      input = ts_input({ outer = '@call.outer', inner = '@call.inner' })
    },
  }
})
