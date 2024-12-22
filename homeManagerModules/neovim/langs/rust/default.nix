{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        extraPackages = attrValues {
          inherit
            (pkgs)
            cargo
            rustc
            rust-analyzer
            rustfmt
            ;
        };

        extraLuaConfig =
          # lua
          ''
            vim.api.nvim_create_autocmd('FileType', {
               pattern = { 'rust' },
               command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            require('lspconfig').rust_analyzer.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            });
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
