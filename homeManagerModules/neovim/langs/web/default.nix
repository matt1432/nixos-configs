self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) vimplugin-ts-error-translator-src;
  inherit (self.lib.${pkgs.system}) buildPlugin;

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
            local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

            local eslintConfig = function()
                local config = vim.lsp.config['eslint'];
                config.before_init = nil;

                vim.lsp.start(vim.tbl_deep_extend('force', config, {
                    capabilities = default_capabilities,

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
                }));
            end;

            vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
                pattern = 'scss',
                command = 'setlocal iskeyword+=@-@',
            });
            local cssConfig = function()
                vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['cssls'], {
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
                }));

                vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['somesass_ls'], {
                    capabilities = default_capabilities,

                    settings = {
                        somesass = {
                            scss = {
                                completion = {
                                    suggestFromUseOnly = true,
                                },
                            },
                        },
                    };
                }));
            end;

            local htmlConfig = function()
                local html_caps = default_capabilities;
                html_caps.textDocument.completion.completionItem.snippetSupport = true;

                vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['html'], {
                    capabilities = html_caps,
                    autostart = false,

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
                }));
            end;

            local typescriptConfig = function()
                vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['ts_ls'], {
                    capabilities = default_capabilities,

                    handlers = {
                        -- format error code with better error message
                        ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
                            require('ts-error-translator').translate_diagnostics(err, result, ctx, config)
                            vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
                        end,
                    },
                }));
            end;

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
                    cssls = cssConfig,
                    eslint = eslintConfig,
                    html = htmlConfig,
                    ts_ls = typescriptConfig,
                },
            });
          '';

        plugins = [
          (buildPlugin "ts-error-translator" vimplugin-ts-error-translator-src)

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
