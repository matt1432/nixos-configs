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
            LoadDevShell({
                name = "python",
                pattern = { "python" },
                pre_shell_callback = function(bufnr)
                    vim.bo[bufnr].ts = 4;
                    vim.bo[bufnr].sw = 4;
                    vim.bo[bufnr].sts = 0;
                    vim.bo[bufnr].expandtab = true;
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
                                        diagnosticMode = "workspace",
                                    },
                                },
                            },
                        })
                    end,
                    ruff = function(start)
                        start()
                    end,
                },
            })
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
