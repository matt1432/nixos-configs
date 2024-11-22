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
        extraPackages = builtins.attrValues {
          inherit
            (pkgs)
            gcc
            clang-tools
            cmake-language-server
            ;
        };

        extraLuaConfig =
          # lua
          ''
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'cpp' , 'c'},
                command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            local lsp = require('lspconfig');

            lsp.cmake.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            });

            lsp.clangd.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),

                handlers = require('lsp-status').extensions.clangd.setup(),
                on_attach = function(_, bufnr)
                    require("clangd_extensions.inlay_hints").setup_autocmd()
                    require("clangd_extensions.inlay_hints").set_inlay_hints()
                end,
            });
          '';

        plugins = builtins.attrValues {
          inherit (pkgs.vimPlugins) clangd_extensions-nvim;
        };
      };
    };
  }
