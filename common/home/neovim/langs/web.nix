{
  config,
  lib,
  pkgs,
  self,
  vimplugin-ts-error-translator-src,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.vars) neovimIde;

  inherit (import "${self}/lib" {inherit pkgs;}) buildPlugin;
in
  mkIf neovimIde {
    programs = {
      neovim = {
        withNodeJs = true;

        extraPackages = builtins.attrValues {
          inherit
            (pkgs)
            nodejs_latest
            vscode-langservers-extracted
            ;

          inherit
            (pkgs.nodePackages)
            npm
            neovim
            ;
        };

        extraLuaConfig =
          # lua
          ''
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'css', 'scss' },
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
            local tsserver = require('typescript-tools');

            tsserver.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),

                handlers = {
                    -- format error code with better error message
                    ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
                        require('ts-error-translator').translate_diagnostics(err, result, ctx, config)
                        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
                    end,
                },
            });

            lsp.eslint.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),

                -- auto-save
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = bufnr,
                        command = 'EslintFixAll',
                    });
                end,

                settings = {
                    validate = 'on',
                    packageManager = 'npm',
                    useESLintClass = true,
                    useFlatConfig = true,
                    experimental = {
                        useFlatConfig = true,
                    },
                    codeAction = {
                        disableRuleComment = {
                            enable = true,
                            location = 'separateLine'
                        },
                        showDocumentation = {
                            enable = true,
                        },
                    },
                    codeActionOnSave = {
                        mode = 'all',
                        rules = {},
                    },
                    format = true,
                    quiet = false,
                    onIgnoredFiles = 'off',
                    rulesCustomizations = {},
                    run = 'onType',
                    problems = {
                        shortenToSingleLine = false,
                    },
                    nodePath = "",
                    workingDirectory = {
                        mode = 'location',
                    },
                    options = {
                        flags = {'unstable_ts_config'},
                    },
                },
            });

            lsp.cssls.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),

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
            });
          '';

        plugins = [
          pkgs.vimPlugins.typescript-tools-nvim
          (buildPlugin "ts-error-translator" vimplugin-ts-error-translator-src)

          {
            plugin = pkgs.vimPlugins.package-info-nvim;
            type = "lua";
            config =
              # lua
              ''
                local packageInfo = require('package-info');
                packageInfo.setup({
                    hide_up_to_date = true,
                    package_manager = 'npm',
                });

                vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
                    pattern = { 'package.json' },
                    callback = function()
                        packageInfo.show({ force = true });
                    end,
                });
              '';
          }
        ];
      };
    };
  }
