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

            loadDevShell({
                name = 'qml',
                pattern = { 'qml' },
                pre_shell_callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                end,
                language_servers = {
                    qmlls = function(start)
                        start({
                            cmd = { 'qmlls', '-E' },
                            root_dir = lsp.util.root_pattern('*.qml', '.git'),
                        });
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
