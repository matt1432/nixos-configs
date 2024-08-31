{
  config,
  lib,
  pkgs,
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
            vscode-langservers-extracted
            yaml-language-server
            ;
        };

        extraLuaConfig =
          # lua
          ''
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'yaml',
                command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'json',
                command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            local lsp = require('lspconfig');

            lsp.jsonls.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            });

            lsp.yamlls.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),

                settings = {
                    yaml = {
                        schemas = {
                            [
                                "https://json.schemastore.org/github-workflow.json"
                            ] = "/.github/workflows/*",
                        },
                    },
                },
            });
          '';
      };
    };
  }
