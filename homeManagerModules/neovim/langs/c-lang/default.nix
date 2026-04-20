{
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
        plugins = [
          {
            plugin = pkgs.vimPlugins.clangd_extensions-nvim;
            type = "lua";
            config = ''
              LoadDevShell({
                  name = "c-lang",
                  pattern = { "cpp", "c", "cuda" },
                  pre_shell_callback = function(bufnr)
                      vim.bo[bufnr].ts = 4
                      vim.bo[bufnr].sw = 4
                      vim.bo[bufnr].sts = 0
                      vim.bo[bufnr].expandtab = true
                  end,
                  language_servers = {
                      cmake = function(start)
                          start()
                      end,

                      clangd = function(start)
                          start({
                              on_attach = function()
                                  require("clangd_extensions").setup()
                              end,
                          })
                      end,
                  },
              })
            '';
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
