local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0));
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil;
end;

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true);
end;

local cmp = require('cmp');

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'cmp_tabnine' },
        { name = 'treesitter' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'vsnip' },
    },

    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body);
        end,
    },

    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item();
            elseif vim.fn['vsnip#available'](1) == 1 then
                feedkey('<Plug>(vsnip-expand-or-jump)', '');
            elseif has_words_before() then
                cmp.complete();
            else
                fallback();
            end;
        end, {
            'i',
            's',
        }),

        ['<S-Tab>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item();
            elseif vim.fn['vsnip#jumpable'](-1) == 1 then
                feedkey('<Plug>(vsnip-jump-prev)', '');
            end;
        end, {
            'i',
            's',
        }),
    },
});
