return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      Colors = require("catppuccin.palettes").get_palette("mocha")
        require("catppuccin").setup({
        transparent_background = true
           })
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },
}
