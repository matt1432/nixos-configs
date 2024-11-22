{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.neovim;
in
  mkIf cfg.enableIde {
    programs = {
      neovim = {
        withPython3 = true;

        extraPackages = [
          pkgs.basedpyright
        ];

        extraLuaConfig =
          # lua
          ''
            require('lspconfig').basedpyright.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            });
          '';
      };
    };
  }
