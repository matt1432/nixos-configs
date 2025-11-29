-- Override netrw
vim.g.loaded_netrw = 0;
vim.g.loaded_netrwPlugin = 0;

local neotreeCmd = require('neo-tree.command');

require('neo-tree').setup({
    close_if_last_window = true,
    enable_refresh_on_write = true,

    window = {
        width = 22,
    },

    filesystem = {
        use_libuv_file_watcher = true,
        group_empty_dirs = true,

        filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {},
            hide_by_pattern = {},
            always_show = {},
            never_show = {},
            never_show_by_pattern = {},
        },

        follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
        },
    },

    source_selector = {
        winbar = true,
        statusline = false,
        truncation_character = '...',
    },
});

local function is_neotree_open()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_get_option_value('ft', { buf = vim.api.nvim_win_get_buf(win) }) == 'neo-tree' then
            return true;
        end;
    end;
    return false;
end;

-- Auto open Neo-Tree on big enough window
vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResized' }, {
    pattern = '*',
    callback = function()
        if vim.api.nvim_eval([[&columns]]) > 100 then
            if is_neotree_open() == false then
                neotreeCmd.execute({ action = 'show' });
                neotreeCmd.execute({ action = 'close' });
                neotreeCmd.execute({ action = 'show' });
            end;
        else
            if is_neotree_open() then
                neotreeCmd.execute({ action = 'close' });
            end;
        end;
    end,
});
