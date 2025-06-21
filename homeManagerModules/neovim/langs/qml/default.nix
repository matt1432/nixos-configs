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
            local lsp = require('lspconfig');
            local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

            loadDevShell({
                name = 'qml',
                pattern = { 'qml' },
                pre_shell_callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                end,
                language_servers = {
                    qmlls = function()
                        vim.lsp.start(vim.tbl_deep_extend('force', vim.lsp.config['qmlls'], {
                            cmd = { 'qmlls', '-E' },
                            root_dir = lsp.util.root_pattern('*.qml', '.git'),
                            capabilities = default_capabilities,
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
