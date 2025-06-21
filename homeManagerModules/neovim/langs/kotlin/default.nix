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
        extraLuaConfig =
          # lua
          ''
            --
            loadDevShell({
                name = 'kotlin',
                pattern = { 'kotlin' },
                pre_shell_callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                end,
                language_servers = {
                    rust_analyzer = function()
                        vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['kotlin_language_server'], {
                            capabilities = require('cmp_nvim_lsp').default_capabilities(),
                        }));
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
