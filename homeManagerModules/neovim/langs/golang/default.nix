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
            local lsp = require('lspconfig');
            local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

            lsp.gopls.setup({
                capabilities = default_capabilities,
                autostart = false,
            });

            vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
                pattern = { 'go', 'gomod', 'gowork', 'gotmpl' },

                callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];

                    if (devShells['golang'] == nil) then
                        devShells['golang'] = 1;

                        require('nix-develop').nix_develop_extend({'${flakeEnv}#golang'}, function()
                            vim.cmd[[LspStart]];
                        end);
                    end
                end,
            });
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
