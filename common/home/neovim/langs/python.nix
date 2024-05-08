{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (pkgs) vimPlugins;
in
  lib.mkIf neovimIde {
    programs = {
      neovim = {
        withPython3 = true;

        extraPython3Packages = ps: [
          ps.pylint
        ];

        plugins = [
          vimPlugins.coc-pyright
        ];
      };
    };
  }
