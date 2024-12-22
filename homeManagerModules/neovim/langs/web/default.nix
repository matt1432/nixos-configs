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
  flakeEnv = config.programs.bash.sessionVariables.FLAKE;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        withNodeJs = true;

        extraLuaConfig =
          # lua
          ''
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'css', 'scss' },

                callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];

                    if (devShells['web'] == nil) then
                        devShells['web'] = 1;

                        require('nix-develop').nix_develop({'${flakeEnv}#web'}, function()
                            vim.cmd[[LspStart]];
                        end);
                    end
                end,
            });

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'html',

                callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 expandtab]];

                    if (devShells['web'] == nil) then
                        devShells['web'] = 1;

                        require('nix-develop').nix_develop({'${flakeEnv}#web'}, function()
                            vim.cmd[[LspStart]];
                        end);
                    end
                end,
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
                autostart = false,

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
                autostart = false,

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
                autostart = false,

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
                autostart = false,
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
  _file = ./default.nix;
}
