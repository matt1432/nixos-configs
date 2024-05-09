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
        plugins = [
          vimPlugins.neodev-nvim
        ];
      };
    };
  }
