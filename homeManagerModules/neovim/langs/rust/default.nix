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
                pattern = { 'rust' },

                callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];

                    if (devShells['rust'] == nil) then
                        devShells['rust'] = 1;

                        require('nix-develop').nix_develop_extend({'${flakeEnv}#rust'}, function()
                            vim.cmd[[LspStart]];
                        end);
                    end
                end,
            });

            require('lspconfig').rust_analyzer.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
                autostart = false,
            });
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
