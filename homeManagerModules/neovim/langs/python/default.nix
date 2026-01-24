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
        initLua =
          # lua
          ''
            local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

            loadDevShell({
                name = 'python',
                pattern = { 'python' },
                pre_shell_callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                end,
                language_servers = {
                    basedpyright = function(start)
                        start({
                            settings = {
                                python = {
                                    pythonPath = vim.fn.exepath("python"),
                                },
                                basedpyright = {
                                    analysis = {
                                        diagnosticMode = 'workspace',
                                    },
                                },
                            },
                        });
                    end,
                    ruff = function(start)
                        start();
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
