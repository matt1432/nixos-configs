{
  config,
  lib,
  pkgs,
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
                pattern = { 'cpp', 'c' },

                callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];

                    if (devShells['c-lang'] == nil) then
                        devShells['c-lang'] = 1;

                        require('nix-develop').nix_develop_extend({'${flakeEnv}#c-lang'}, function()
                            vim.cmd[[LspStart]];
                        end);
                    end
                end,
            });
          '';

        plugins = [
          {
            plugin = pkgs.vimPlugins.clangd_extensions-nvim;
            type = "lua";
            config =
              # lua
              ''
                --
                local lsp = require('lspconfig');
                local default_capabilities = require('cmp_nvim_lsp').default_capabilities();


                lsp.cmake.setup({
                    capabilities = default_capabilities,
                    autostart = false,
                });

                lsp.clangd.setup({
                    capabilities = default_capabilities,
                    autostart = false,

                    on_attach = function(_, bufnr)
                        require('clangd_extensions').setup();
                    end,
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
