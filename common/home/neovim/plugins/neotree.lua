-- Override netrw
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0

require('neo-tree').setup({
  close_if_last_window = true,
  enable_refresh_on_write = true,

  window = {
    width = 22,
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
