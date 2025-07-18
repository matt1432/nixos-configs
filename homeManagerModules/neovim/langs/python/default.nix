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
                name = 'python',
                pattern = { 'python' },
                pre_shell_callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                end,
                language_servers = {
                    basedpyright = function()
                        vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['basedpyright'], {
                            capabilities = default_capabilities,
                            settings = {
                                python = {
                                    pythonPath = vim.fn.exepath("python"),
                                },
                            },
                        }));
                    end,
                    ruff = function()
                        vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['ruff'], {
                            capabilities = default_capabilities,
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
