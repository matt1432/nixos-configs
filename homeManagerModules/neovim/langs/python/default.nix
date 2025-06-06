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

            lsp.basedpyright.setup({
                capabilities = default_capabilities,
                autostart = false,
                settings = {
                    python = {
                        pythonPath = vim.fn.exepath("python"),
                    },
                },
            });

            lsp.ruff.setup({
                capabilities = default_capabilities,
                autostart = false,
            });

            vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
                pattern = { 'python' },

                callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];

                    if (devShells['python'] == nil) then
                        devShells['python'] = 1;

                        require('nix-develop').nix_develop_extend({'${flakeEnv}#python'}, function()
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
