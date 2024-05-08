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
      # I love doing typos
      bash.shellAliases = {
        nivm = "nvim";
        nivim = "nvim";
      };

      neovim = {
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        extraLuaConfig =
          /*
          lua
          */
          ''
            vim.api.nvim_create_autocmd("FileType", {
               pattern = 'sh',
               command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });
          '';

        coc.settings = {
          # Bash
          bashIde.shellcheckPath = "${pkgs.shellcheck}/bin/shellcheck";
        };

        plugins = [
          vimPlugins.coc-sh
        ];
      };
    };
  }
