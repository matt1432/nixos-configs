{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;
  inherit (pkgs.writers) writeYAML;

  cfg = config.programs.neovim;
in
  mkIf cfg.enableIde {
    xdg.configFile."clangd/config.yaml".source = writeYAML "config.yaml" {
      CompileFlags.Add = ["-D__cpp_concepts=202002L"];
    };

    programs = {
      neovim = {
        extraPackages = attrValues {
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
                pattern = { 'cpp', 'c' },
                command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            local lsp = require('lspconfig');
            local default_capabilities = require('cmp_nvim_lsp').default_capabilities();
            local clangd_extensions = require('clangd_extensions.inlay_hints');

            lsp.cmake.setup({
                capabilities = default_capabilities,
            });

            lsp.clangd.setup({
                capabilities = default_capabilities,

                handlers = require('lsp-status').extensions.clangd.setup(),

                on_attach = function(_, bufnr)
                    clangd_extensions.setup_autocmd();
                    clangd_extensions.set_inlay_hints();
                end,
            });
          '';

        plugins = attrValues {
          inherit
            (pkgs.vimPlugins)
            clangd_extensions-nvim
            ;
        };
      };
    };
  }
