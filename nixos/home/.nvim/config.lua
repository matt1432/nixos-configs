vim.opt.fillchars = {eob = " "}
vim.cmd[[colorscheme dracula]]

-- Set up nvim-cmp.
  local cmp = require'cmp'
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })
  cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- https://github.com/AstroNvim/AstroNvim/issues/648#issuecomment-1511728897

vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0

-- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/983#issuecomment-1637372234
