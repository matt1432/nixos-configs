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
                        lua_ls = function()
                            require('lazydev').setup({
                                library = {
                                    -- Load luvit types when the `vim.uv` word is found
                                    { path = '${pkgs.vimPlugins.luvit-meta}/library', words = { 'vim%.uv' } },
                                },
                            });

                            vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['lua_ls'], {
                                capabilities = require('cmp_nvim_lsp').default_capabilities(),
                            }));
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
