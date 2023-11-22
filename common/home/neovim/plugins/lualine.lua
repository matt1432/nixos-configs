require('lualine').setup({
  options = {
    theme = 'dracula',
    globalstatus = true,
  },
  sections = {
    lualine_x = {'g:coc_status', 'bo:filetype'},
  }
})
