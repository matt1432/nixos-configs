self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) fileContents mkIf mkOption types;

  cfg = config.programs.neovim;
in {
  imports = [
    (import ./git self)
    (import ./langs self)
    (import ./theme self)
  ];

  options.programs.neovim = {
    user = mkOption {
      type = types.str;
    };

    ideConfig = {
      enableBash = mkOption {
        type = types.bool;
        default = true;
      };
      enableJava = mkOption {
        type = types.bool;
        default = true;
      };
      enableNix = mkOption {
        type = types.bool;
        default = true;
      };
      enableWeb = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      initLua =
        # lua
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

          -- Always show the signcolumn, otherwise it would shift
          -- the text each time diagnostics appear/become resolved
          vim.opt.signcolumn = 'yes';

          -- remove highlight on words
          vim.keymap.set('n', '<esc>', ':noh<cr><esc>', {
              noremap = true,
              silent = true,
          });

          -- https://github.com/seblj/roslyn.nvim/issues/121#issuecomment-2544076963
          vim.opt.cmdheight = 2;
        '';

      plugins = [
        pkgs.vimPlugins.fzfWrapper
        pkgs.vimPlugins.fzf-vim

        {
          plugin = pkgs.vimPlugins.todo-comments-nvim;
          type = "lua";
          config = ''
            require('todo-comments').setup();
          '';
        }
        {
          plugin = pkgs.vimPlugins.mini-nvim;
          type = "lua";
          config = fileContents ./config/mini.lua;
        }

        {
          plugin = pkgs.vimPlugins.nvim-config-local;
          type = "lua";
          config = ''
            require('config-local').setup({
                config_files = { '.nvim.lua', '.nvimrc', '.exrc' },

                -- Where the plugin keeps files data
                hashfile = '${config.xdg.cacheHome}/nvim/config-local',
            });
          '';
        }
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
