{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        extraLuaConfig =
          # lua
          ''
            --
            local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

            loadDevShell({
                name = 'json',
                pattern = { 'json', 'yaml', '.clang-.*' },
                pre_shell_callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                end,
                language_servers = {
                    jsonls = function()
                        vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['jsonls'], {
                            capabilities = default_capabilities,
                        }));
                    end,

                    yamlls = function()
                        vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['yamlls'], {
                            capabilities = default_capabilities,

                            settings = {
                                yaml = {
                                    format = {
                                        enable = true,
                                        singleQuote = true,
                                    },
                                    schemas = {
                                        [
                                            "https://json.schemastore.org/github-workflow.json"
                                        ] = "/.github/workflows/*",
                                    },
                                },
                            },
                        }));
                    end,
                },
            });
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
