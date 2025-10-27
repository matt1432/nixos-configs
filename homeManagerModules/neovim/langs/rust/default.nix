{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        extraPackages = attrValues {
          inherit (pkgs) rust-analyzer;
        };

        extraLuaConfig =
          # lua
          ''
            --
            vim.lsp.enable('rust_analyzer');
            vim.lsp.config('rust_analyzer', {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            });

            vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
                pattern = { 'rust' },

                callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                end,
            });
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
