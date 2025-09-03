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
            config =
              # lua
              ''
                --
                loadDevShell({
                    name = 'lua',
                    pattern = { 'lua' },
                    pre_shell_callback = function()
                        vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                    end,
                    language_servers = {
                        lua_ls = function(start)
                            require('lazydev').setup({
                                library = {
                                    -- Load luvit types when the `vim.uv` word is found
                                    { path = '${pkgs.vimPlugins.luvit-meta}/library', words = { 'vim%.uv' } },
                                },
                            });

                            start();
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
