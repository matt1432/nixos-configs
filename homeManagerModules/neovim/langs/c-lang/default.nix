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
                local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

                loadDevShell({
                    name = 'c-lang',
                    pattern = { 'cpp', 'c' },
                    pre_shell_callback = function()
                        vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                    end,
                    language_servers = {
                        cmake = function()
                            vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['cmake'], {
                                capabilities = default_capabilities,
                            }));
                        end,

                        clangd = function()
                            vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['clangd'], {
                                capabilities = default_capabilities,

                                on_attach = function(_, bufnr)
                                    require('clangd_extensions').setup();
                                end,
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
