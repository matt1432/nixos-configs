self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) vimplugin-ts-error-translator-src;
  inherit (self.lib.${pkgs.system}) buildPlugin;

  inherit (lib) attrValues mkIf;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enableIde {
    programs = {
      neovim = {
        withNodeJs = true;

        extraPackages = attrValues {
          inherit
            (pkgs)
            neovim-node-client
            nodejs_latest
            vscode-langservers-extracted
            ;

          inherit
            (pkgs.nodePackages)
            npm
            ;

          inherit
            (self.packages.${pkgs.system})
            some-sass-language-server
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
                command = 'setlocal ts=4 sw=4 expandtab',
            });

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'scss',
                command = 'setlocal iskeyword+=@-@',
            });

            local lsp = require('lspconfig');
            local tsserver = require('typescript-tools');
            local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

            tsserver.setup({
                capabilities = default_capabilities,

                handlers = {
                    -- format error code with better error message
                    ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
                        require('ts-error-translator').translate_diagnostics(err, result, ctx, config)
                        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
                    end,
                },
            });

            lsp.eslint.setup({
                capabilities = default_capabilities,

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
                        flags = { 'unstable_ts_config' },
                    },
                },
            });

            lsp.cssls.setup({
                capabilities = default_capabilities,

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

            lsp.somesass_ls.setup({
                capabilities = default_capabilities,
            });
            lsp.somesass_ls.manager.config.settings = {
                somesass = {
                    scss = {
                        completion = {
                            suggestFromUseOnly = true,
                        },
                    },
                },
            };

            local html_caps = default_capabilities;
            html_caps.textDocument.completion.completionItem.snippetSupport = true;

            lsp.html.setup({
                capabilities = html_caps,
                settings = {
                    configurationSection = { "html", "css", "javascript" },
                    embeddedLanguages = {
                        css = true,
                        javascript = true,
                    },
                    provideFormatter = true,
                    tabSize = 4,
                    insertSpaces = true,
                    indentEmptyLines = false,
                    wrapAttributes = 'auto',
                    wrapAttributesIndentSize = 4,
                    endWithNewline = true,
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
  };

  # For accurate stack trace
  _file = ./web.nix;
}
