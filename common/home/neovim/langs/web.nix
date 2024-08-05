{
  config,
  lib,
  pkgs,
  self,
  vimplugin-ts-error-translator-src,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (pkgs) vimPlugins;

  inherit (import "${self}/lib.nix" {inherit pkgs;}) buildPlugin;
in
  lib.mkIf neovimIde {
    programs = {
      neovim = {
        withNodeJs = true;

        extraPackages = [
          pkgs.nodejs_latest
          pkgs.nodePackages.npm
          pkgs.nodePackages.neovim

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
          vimPlugins.typescript-tools-nvim
          (buildPlugin "ts-error-translator" vimplugin-ts-error-translator-src)

          {
            plugin = vimPlugins.package-info-nvim;
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
