{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (lib) fileContents optionals;
  inherit (pkgs) vimPlugins;
in {
  imports = [
    ./coc.nix
    ./langs
    ./theme.nix
    ./treesitter.nix
  ];

  programs = {
    neovim = {
      enable = true;

      extraLuaConfig =
        /*
        lua
        */
        ''
          -- by default, the indent is 2 spaces.
          vim.opt.smartindent = true;
          vim.opt.expandtab = true;
          vim.opt.shiftwidth = 2;
          vim.opt.softtabstop = 2;
          vim.opt.tabstop = 2;

          vim.opt.number = true;
          vim.opt.relativenumber = true;

          vim.opt.undofile = true;
          vim.opt.undodir = '${config.xdg.cacheHome}/nvim/';

          -- remove highlight on words
          vim.cmd[[nnoremap <silent> <esc> :noh<cr><esc>]];
        '';

      plugins =
        [
          vimPlugins.fzfWrapper
          vimPlugins.fzf-vim
          vimPlugins.fugitive
          {
            plugin = vimPlugins.todo-comments-nvim;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                require('todo-comments').setup();
              '';
          }
          {
            plugin = vimPlugins.gitsigns-nvim;
            type = "lua";
            config = fileContents ./plugins/gitsigns.lua;
          }
          {
            plugin = vimPlugins.mini-nvim;
            type = "lua";
            config = fileContents ./plugins/mini.lua;
          }
          {
            plugin = vimPlugins.codewindow-nvim;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                require('codewindow').setup({
                    auto_enable = true,
                    minimap_width = 8,
                    relative = 'editor',
                    window_border = 'none',
                });
              '';
          }
        ]
        ++ optionals neovimIde [
          {
            plugin = vimPlugins.nvim-autopairs;
            type = "lua";
            config = fileContents ./plugins/autopairs.lua;
          }
        ];
    };
  };
}
