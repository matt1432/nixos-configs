-- Override netrw
vim.g.loaded_netrw = 0;
vim.g.loaded_netrwPlugin = 0;

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
    statusline = false,
  },

  follow_current_file = {
    enabled = true,
    leave_dirs_open = true,
  },
});

local function is_neotree_open()
  local manager = require("neo-tree.sources.manager");
  local renderer = require("neo-tree.ui.renderer");
  local state = manager.get_state("filesystem");
  return renderer.window_exists(state);
end

-- Auto open Neo-Tree on big enough window
vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResized' }, {
  pattern = '*',
  callback = function()
    if vim.api.nvim_eval([[&columns]]) > 100 then
      if is_neotree_open() == false then
        vim.cmd [[Neotree show]];
        vim.cmd [[Neotree close]];
        vim.cmd [[Neotree show]];
      end
    else
      if is_neotree_open() then
        vim.cmd [[Neotree close]];
      end
    end
  end,
});
