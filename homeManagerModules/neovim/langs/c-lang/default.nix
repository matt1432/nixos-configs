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

                local clangd_extensions = require('clangd_extensions.inlay_hints');

                lsp.cmake.setup({
                    capabilities = default_capabilities,
                    autostart = false,
                });

                lsp.clangd.setup({
                    capabilities = default_capabilities,
                    autostart = false,

                    handlers = require('lsp-status').extensions.clangd.setup(),

                    on_attach = function(_, bufnr)
                        clangd_extensions.setup_autocmd();
                        clangd_extensions.set_inlay_hints();
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
