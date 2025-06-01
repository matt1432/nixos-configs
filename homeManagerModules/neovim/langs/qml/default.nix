{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.neovim;
  flakeEnv = config.programs.bash.sessionVariables.FLAKE;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        extraLuaConfig =
          # lua
          ''
            --
            vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
                pattern = { 'qml' },

                callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];

                    if (devShells['qml'] == nil) then
                        devShells['qml'] = 1;

                        require('nix-develop').nix_develop_extend({'${flakeEnv}#qml'}, function()
                            vim.cmd[[LspStart]];
                        end);
                    end
                end,
            });

            local lsp = require('lspconfig');
            local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

            lsp.qmlls.setup({
                cmd = { 'qmlls', '-E' },
                root_dir = lsp.util.root_pattern('*.qml', '.git'),
                capabilities = default_capabilities,
                autostart = false,
            });
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
