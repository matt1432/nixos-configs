{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.neovim;
in {
  config = mkIf (cfg.enable && cfg.ideConfig.enableGolang) {
    programs = {
      neovim = {
        extraPackages = with pkgs; [go gopls];

        plugins = [
          {
            plugin = pkgs.vimPlugins.clangd_extensions-nvim;
            type = "lua";
            config =
              # lua
              ''
                local lsp = require('lspconfig');
                local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

                lsp.gopls.setup({
                    cmd = { '${pkgs.gopls}/bin/gopls' },
                    capabilities = default_capabilities,
                });
              '';
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
