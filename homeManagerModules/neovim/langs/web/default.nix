self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) mkIf optionalString;

  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  cfg = config.programs.neovim;
in {
  config = mkIf (cfg.enable && cfg.ideConfig.enableWeb) {
    home.packages = attrValues {
      inherit
        (pkgs)
        corepack_24
        neovim-node-client
        vscode-langservers-extracted
        typescript-language-server
        ;

      inherit
        (pkgs.selfPackages)
        some-sass-language-server
        ;
    };

    programs = {
      neovim = {
        withNodeJs = true;

        initLua =
          # lua
          ''
            vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
                pattern = 'scss',
                command = 'setlocal iskeyword+=@-@',
            });

            vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
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
                callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                end,
            });

            vim.lsp.enable('ts_ls');
            vim.lsp.config('ts_ls', {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            });

            vim.lsp.enable('cssls');
            vim.lsp.config('cssls', {
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

            vim.lsp.enable('eslint');
            vim.lsp.config('eslint', {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),

                root_dir = function(bufnr, on_dir)
                    local root = vim.fs.root(bufnr, {
                        ".eslintrc",
                        ".eslintrc.js",
                        ".eslintrc.cjs",
                        ".eslintrc.yaml",
                        ".eslintrc.yml",
                        ".eslintrc.json",
                        "eslint.config.js",
                        "eslint.config.mjs",
                        "eslint.config.cjs",
                        "eslint.config.ts",
                        "eslint.config.mts",
                        "eslint.config.cts",
                        "package.json",
                    });
                    if root then
                        on_dir(root);
                    else
                        local git_root = util.find_git_ancestor(vim.api.nvim_buf_get_name(bufnr));
                        if git_root then
                            on_dir(git_root);
                        end
                    end
                end,

                settings = {
                    codeActionOnSave = {
                        mode = 'all',
                        rules = {},
                    },
              ${optionalString isDarwin
              # lua
              ''
                rulesCustomizations = {
                    {
                        rule = '@typescript-eslint/naming-convention',
                        severity = 'off',
                        fixable = false,
                    },
                },
              ''}
                },
            });

            vim.lsp.config['eslint'].before_init = nil;

            local html_caps = require('cmp_nvim_lsp').default_capabilities();
            html_caps.textDocument.completion.completionItem.snippetSupport = true;

            vim.lsp.enable('html');
            vim.lsp.config('html', {
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
          {
            plugin = pkgs.vimPlugins.package-info-nvim;
            type = "lua";
            config = ''
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
