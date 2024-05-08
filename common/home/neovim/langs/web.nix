{
  config,
  pkgs,
  lib,
  coc-stylelintplus,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (pkgs) vimPlugins;

  coc-stylelintplus-flake = coc-stylelintplus.packages.${pkgs.system}.default;
in
  lib.mkIf neovimIde {
    programs = {
      neovim = {
        withNodeJs = true;

        extraPackages = with pkgs; [
          nodejs_latest
          nodePackages.npm
          nodePackages.neovim
        ];

        extraLuaConfig =
          /*
          lua
          */
          ''
            vim.api.nvim_create_autocmd("FileType", {
               pattern = { 'javascript' , 'typescript'},
               command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            vim.api.nvim_create_autocmd("FileType", {
               pattern = 'html',
               command = 'setlocal ts=2 sw=2 expandtab',
            });

            vim.api.nvim_create_autocmd("FileType", {
               pattern = 'scss',
               command = 'setl iskeyword+=@-@',
            });
          '';

        coc.settings = {
          # ESLint
          eslint = {
            format.enable = true;
            autoFixOnSave = true;
          };

          # Stylelint
          stylelintplus = {
            enable = true;
            cssInJs = true;
            autoFixOnSave = true;
            autoFixOnFormat = true;
          };
          css.validate = false;
          less.validate = false;
          scss.validate = false;
          wxss.validate = false;
        };

        plugins = [
          vimPlugins.coc-css
          vimPlugins.coc-eslint
          coc-stylelintplus-flake
          vimPlugins.coc-tsserver
        ];
      };
    };
  }
