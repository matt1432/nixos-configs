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
        extraPackages = [
          pkgs.vscode-langservers-extracted
          pkgs.yaml-language-server
        ];

        extraLuaConfig =
          /*
          lua
          */
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
            local coq = require('coq');

            lsp.jsonls.setup(coq.lsp_ensure_capabilities({}));

            lsp.yamlls.setup(coq.lsp_ensure_capabilities({
                settings = {
                    yaml = {
                        schemas = {
                            [
                                "https://json.schemastore.org/github-workflow.json"
                            ] = "/.github/workflows/*",
                        },
                    },
                },
            }));
          '';
      };
    };
  }
