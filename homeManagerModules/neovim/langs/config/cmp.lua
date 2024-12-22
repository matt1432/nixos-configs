local cmp = require('cmp');
local cmp_autopairs = require('nvim-autopairs.completion.cmp');

cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
);

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    },

    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body);
        end,
    },

    mapping = {
        -- Confirm selection
        ['<Right>'] = cmp.mapping.confirm({ select = true }),

        -- Next selection
        ['<Down>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item();
            else
                fallback();
            end;
        end, {
            'i',
            's',
        }),

        -- Previous selection
        ['<Up>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item();
            else
                fallback();
            end;
        end, {
            'i',
            's',
        }),
    },
});
