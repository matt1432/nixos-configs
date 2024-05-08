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
                vim.cmd[[set list listchars=tab:\ \ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨]]

                -- Add visual indicator for trailing whitespaces
                vim.opt.fillchars = {eob = " "}

                vim.cmd[[colorscheme dracula]]
              '';
          }
          {
            plugin = vimPlugins.indent-blankline-nvim;
            type = "lua";
            config = fileContents ./plugins/indent.lua;
          }
        ]
        ++ optionals neovimIde [
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
                        lualine_x = { 'g:coc_status', 'bo:filetype' },
                    },
                });
              '';
          }
          {
            plugin = vimPlugins.neo-tree-nvim;
            type = "viml";
            config = ''
              ${fileContents ./plugins/neotree.vim}

              lua << EOF
                ${fileContents ./plugins/neotree.lua}
              EOF
            '';
          }
        ];
    };
  };
}
