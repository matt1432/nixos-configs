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
        extraPackages = with pkgs; [
          gcc
          clang-tools
        ];

        plugins = [
          vimPlugins.coc-clangd
          vimPlugins.coc-cmake
        ];
      };
    };
  }
