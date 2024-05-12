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
        plugins = [
          vimPlugins.markdown-preview-nvim

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
