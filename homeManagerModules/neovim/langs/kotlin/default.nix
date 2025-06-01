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
                pattern = { 'kotlin' },

                callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];

                    if (devShells['kotlin'] == nil) then
                        devShells['kotlin'] = 1;

                        require('nix-develop').nix_develop_extend({'${flakeEnv}#kotlin'}, function()
                            vim.cmd[[LspStart]];
                        end);
                    end
                end,
            });

            local lsp = require('lspconfig');
            local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

            lsp.kotlin_language_server.setup({
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
