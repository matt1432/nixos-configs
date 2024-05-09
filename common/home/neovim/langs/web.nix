{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (pkgs) vimPlugins;
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

        plugins = [
        ];
      };
    };
  }
