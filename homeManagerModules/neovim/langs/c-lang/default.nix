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
            config =
              # lua
              ''
                --
                loadDevShell({
                    name = 'c-lang',
                    pattern = { 'cpp', 'c', 'cuda' },
                    pre_shell_callback = function()
                        vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                    end,
                    language_servers = {
                        cmake = function(start)
                            start();
                        end,

                        clangd = function(start)
                            start({
                                on_attach = function(_, bufnr)
                                    require('clangd_extensions').setup();
                                end,
                            });
                        end,
                    },
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
