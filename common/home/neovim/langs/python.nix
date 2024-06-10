{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.vars) neovimIde;
in
  lib.mkIf neovimIde {
    programs = {
      neovim = {
        withPython3 = true;

        extraPackages = [
          pkgs.basedpyright
        ];

        extraLuaConfig =
          # lua
          ''
            require('lspconfig').basedpyright.setup(
                require('coq').lsp_ensure_capabilities({}));
          '';
      };
    };
  }
