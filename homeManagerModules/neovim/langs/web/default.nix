self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        withNodeJs = true;

        extraLuaConfig =
          # lua
          ''
            --
            vim.lsp.config['eslint'].before_init = nil;

            vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
                pattern = 'scss',
                command = 'setlocal iskeyword+=@-@',
            });

            loadDevShell({
                name = 'web',
                pattern = {
                    'javascript',
                    'javascriptreact',
                    'javascript.jsx',
                    'typescript',
                    'typescriptreact',
                    'typescript.tsx',
                    'css',
                    'scss',
                    'html',
                },
                pre_shell_callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                end,
                language_servers = {
                    cssls = function(start)
                        start({
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
                    end,

                    somesass_ls = function(start)
                        start({
                            settings = {
                                somesass = {
                                    scss = {
                                        completion = {
                                            suggestFromUseOnly = true,
                                        },
                                    },
                                },
                            };
                        });
                    end,

                    eslint = function(start)
                        start({
                            -- auto-save
                            on_attach = function(client, bufnr)
                                vim.lsp.config['eslint'].on_attach(client, bufnr);

                                vim.api.nvim_create_autocmd('BufWritePre', {
                                    buffer = bufnr,
                                    command = 'LspEslintFixAll',
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
                    end,

                    html = function(start)
                        local html_caps = require('cmp_nvim_lsp').default_capabilities();
                        html_caps.textDocument.completion.completionItem.snippetSupport = true;

                        start({
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
                    end,

                    ts_ls = function(start)
                        start();
                    end,
                },
            });
          '';

        plugins = [
          {
            plugin = pkgs.vimPlugins.package-info-nvim;
            type = "lua";
            config =
              # lua
              ''
                --
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
  _file = ./default.nix;
}
