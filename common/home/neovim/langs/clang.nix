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
          cmake-language-server
        ];

        extraLuaConfig =
          # lua
          ''
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'cpp' , 'c'},
                command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            local lsp = require('lspconfig');
            local coq = require('coq');

            lsp.cmake.setup(coq.lsp_ensure_capabilities({}));

            lsp.clangd.setup(coq.lsp_ensure_capabilities({
                handlers = require('lsp-status').extensions.clangd.setup(),
                on_attach = function(_, bufnr)
                    require("clangd_extensions.inlay_hints").setup_autocmd()
                    require("clangd_extensions.inlay_hints").set_inlay_hints()
                end,
            }));
          '';

        plugins = [
          vimPlugins.clangd_extensions-nvim
        ];
      };
    };
  }
