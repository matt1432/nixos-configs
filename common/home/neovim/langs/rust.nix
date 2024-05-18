{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.vars) neovimIde;
in
  lib.mkIf neovimIde {
    programs = {
      neovim = {
        extraPackages = with pkgs; [
          cargo
          rustc
          rust-analyzer
          rustfmt
        ];

        extraLuaConfig =
          /*
          lua
          */
          ''
            vim.api.nvim_create_autocmd('FileType', {
               pattern = { 'rust' },
               command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            local lsp = require('lspconfig');
            local coq = require('coq');

            lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities({}));
          '';
      };
    };
  }
