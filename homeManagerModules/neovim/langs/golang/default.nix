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
                name = "golang",
                pattern = { "go", "gomod", "gowork", "gotmpl" },
                pre_shell_callback = function(bufnr)
                    vim.bo[bufnr].ts = 4;
                    vim.bo[bufnr].sw = 4;
                    vim.bo[bufnr].sts = 0;
                    vim.bo[bufnr].expandtab = true;
                end,
                language_servers = {
                    gopls = function(start)
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
