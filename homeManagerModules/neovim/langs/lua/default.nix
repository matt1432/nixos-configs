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
            plugin = pkgs.vimPlugins.lazydev-nvim;
            type = "lua";
            config = ''
              LoadDevShell({
                  name = "lua",
                  pattern = { "lua" },
                  pre_shell_callback = function(bufnr)
                      vim.bo[bufnr].ts = 4;
                      vim.bo[bufnr].sw = 4;
                      vim.bo[bufnr].sts = 0;
                      vim.bo[bufnr].expandtab = true;
                  end,
                  language_servers = {
                      lua_ls = function(start)
                          require("lazydev").setup({
                              library = {
                                  -- Load luvit types when the `vim.uv` word is found
                                  { path = "${pkgs.vimPlugins.luvit-meta}/library", words = { "vim%.uv" } },
                              },
                          })

                          start()
                      end,
                  },
              })

              require("conform").formatters_by_ft.lua = { "stylua" }
            '';
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
