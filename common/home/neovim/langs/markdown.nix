{
  config,
  pkgs,
  lib,
  vimplugin-easytables-src,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (pkgs) vimPlugins;

  buildPlugin = pname: src:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.shortRev;
    };
in
  lib.mkIf neovimIde {
    programs = {
      neovim = {
        coc.settings = {
          markdownlint.config = {
            no-trailing-spaces = true;
            no-multiple-blanks = false;
            no-duplicate-heading = false;
            line-length = {
              tables = false;
            };
          };
        };

        plugins = [
          vimPlugins.markdown-preview-nvim
          vimPlugins.coc-markdownlint
          {
            plugin = buildPlugin "easytables-nvim" vimplugin-easytables-src;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                require('easytables').setup();
              '';
          }
        ];
      };
    };
  }
