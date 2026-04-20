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
            local lsp = require("lspconfig")

            LoadDevShell({
                name = "qml",
                pattern = { "qml" },
                pre_shell_callback = function(bufnr)
                    vim.bo[bufnr].ts = 4;
                    vim.bo[bufnr].sw = 4;
                    vim.bo[bufnr].sts = 0;
                    vim.bo[bufnr].expandtab = true;
                end,
                language_servers = {
                    qmlls = function(start)
                        start({
                            cmd = { "qmlls", "-E" },
                            root_dir = lsp.util.root_pattern("*.qml", ".git"),
                        })
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
