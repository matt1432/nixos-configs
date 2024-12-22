{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.programs.neovim;

  flakeEnv = config.programs.bash.sessionVariables.FLAKE;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        extraPackages = attrValues {
          inherit
            (pkgs)
            lua-language-server
            ;
        };

        plugins = [
          {
            plugin = pkgs.vimPlugins.neodev-nvim;
            type = "lua";
            config =
              # lua
              ''
                local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

                vim.api.nvim_create_autocmd('FileType', {
                    pattern = 'lua',
                    command = 'setlocal ts=4 sw=4 sts=0 expandtab',
                });

                -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
                require("neodev").setup({
                    override = function(root_dir, library)
                        if root_dir:find('${flakeEnv}', 1, true) == 1 then
                            library.enabled = true;
                            library.plugins = true;
                        end
                    end,
                });

                require('lspconfig').lua_ls.setup({
                    capabilities = default_capabilities,
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
