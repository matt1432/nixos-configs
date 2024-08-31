{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.vars) neovimIde;
in
  mkIf neovimIde {
    programs = {
      neovim = {
        extraPackages = builtins.attrValues {
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
  }
