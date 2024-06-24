{
  config,
  pkgs,
  lib,
  stylelint-lsp,
  vimplugin-ts-error-translator-src,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (pkgs) vimPlugins;

  inherit (import ../../../../lib.nix {inherit pkgs;}) buildPlugin;
in
  lib.mkIf neovimIde {
    programs = {
      neovim = {
        withNodeJs = true;

        extraPackages = [
          pkgs.nodejs_latest
          pkgs.nodePackages.npm
          pkgs.nodePackages.neovim

          stylelint-lsp.packages.${pkgs.system}.default
          pkgs.vscode-langservers-extracted
        ];

        extraLuaConfig =
          # lua
          ''
            vim.api.nvim_create_autocmd('FileType', {
               pattern = { 'javascript', 'typescript', 'css', 'scss' },
               command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            vim.api.nvim_create_autocmd('FileType', {
               pattern = 'html',
               command = 'setlocal ts=2 sw=2 expandtab',
            });

            vim.api.nvim_create_autocmd('FileType', {
               pattern = 'scss',
               command = 'setlocal iskeyword+=@-@',
            });

            local lsp = require('lspconfig');
            local coq = require('coq');
            local tsserver = require('typescript-tools');

            tsserver.setup(coq.lsp_ensure_capabilities({
                handlers = {
                    -- format error code with better error message
                    ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
                        require('ts-error-translator').translate_diagnostics(err, result, ctx, config)
                        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
                    end,
                },
            }));

            lsp.eslint.setup(coq.lsp_ensure_capabilities({
                -- auto-save
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = bufnr,
                        command = 'EslintFixAll',
                    });
                end,
            }));

            lsp.cssls.setup(coq.lsp_ensure_capabilities({
                settings = {
                    css = {
                        validate = false,
                    },
                    less = {
                        validate = false,
                    },
                    scss = {
                        validate = false,
                    },
                },
            }));

            lsp.stylelint_lsp.setup(coq.lsp_ensure_capabilities({
                settings = {
                    stylelintplus = {},
                },
            }));
          '';

        plugins = [
          vimPlugins.typescript-tools-nvim
          (buildPlugin "ts-error-translator" vimplugin-ts-error-translator-src)
        ];
      };
    };
  }
