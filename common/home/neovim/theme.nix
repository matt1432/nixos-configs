{
  config,
  pkgs,
  lib,
  nvim-theme-src,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (lib) fileContents optionals;
  inherit (pkgs) vimPlugins;
in {
  programs = {
    neovim = {
      extraPackages = with pkgs; [
        bat
      ];

      plugins =
        [
          {
            plugin = vimPlugins.dracula-nvim.overrideAttrs {
              src = nvim-theme-src;
            };
            type = "lua";
            config =
              /*
              lua
              */
              ''
                -- set dot icon in place of trailing whitespaces
                vim.opt.listchars = {
                    tab = '→ ',
                    trail = '•',
                    extends = '⟩',
                    precedes = '⟨',
                    nbsp = '␣',
                };
                vim.opt.list = true;

                -- Add visual indicator for trailing whitespaces
                vim.opt.fillchars = { eob = " " };
                vim.fn.matchadd('errorMsg', [[\s\+$]]);

                vim.cmd.colorscheme('dracula');
              '';
          }
          {
            plugin = vimPlugins.indent-blankline-nvim;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                local highlight = {
                    "RainbowRed",
                    "RainbowYellow",
                    "RainbowBlue",
                    "RainbowOrange",
                    "RainbowGreen",
                    "RainbowViolet",
                    "RainbowCyan",
                };

                local hooks = require('ibl.hooks');
                hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                    vim.api.nvim_set_hl(0, "RainbowRed",    { fg = "#E06C75" })
                    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                    vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = "#61AFEF" })
                    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                    vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = "#98C379" })
                    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                    vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = "#56B6C2" })
                end);

                require('ibl').setup({
                    indent = {
                        highlight = highlight,
                        char = "▏",
                    },
                });
              '';
          }
          {
            plugin = vimPlugins.lualine-nvim;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                require('lualine').setup({
                    options = {
                        theme = 'dracula',
                        globalstatus = true,
                    },
                    sections = {
                        lualine_x = { 'bo:filetype' },
                    },
                });
              '';
          }
        ]
        ++ optionals neovimIde [
          {
            plugin = vimPlugins.neo-tree-nvim;
            type = "lua";
            config = fileContents ./neotree.lua;
          }
          {
            plugin = vimPlugins.codewindow-nvim;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                local codewindow = require('codewindow');

                codewindow.setup({
                    auto_enable = false,
                    minimap_width = 8,
                    relative = 'editor',
                    window_border = 'none',
                    exclude_filetypes = { 'help' },
                });

                vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResized' }, {
                    pattern = '*',
                    callback = function()
                        if vim.api.nvim_win_get_width(0) < 88 then
                            codewindow.close_minimap();
                        else
                            codewindow.open_minimap();
                        end
                    end,
                });
              '';
          }
          {
            plugin = vimPlugins.transparent-nvim;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                require("transparent").setup({
                    groups = {
                      'Normal', 'NormalNC', 'Comment', 'Constant',
                      'Special', 'Identifier', 'Statement', 'PreProc',
                      'Type', 'Underlined', 'Todo', 'String', 'Function',
                      'Conditional', 'Repeat', 'Operator', 'Structure',
                      'LineNr', 'NonText', 'SignColumn', 'CursorLine',
                      'CursorLineNr', 'StatusLine', 'StatusLineNC',
                      'EndOfBuffer',
                    },
                    extra_groups = {},
                    exclude_groups = {},
                });
              '';
          }
        ];
    };
  };
}
