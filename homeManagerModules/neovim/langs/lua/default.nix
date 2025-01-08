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
        plugins = [
          {
            plugin = pkgs.vimPlugins.lazydev-nvim;
            type = "lua";
            config =
              # lua
              ''
                local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

                vim.api.nvim_create_autocmd('FileType', {
                    pattern = 'lua',

                    callback = function()
                        vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];

                        if (devShells['lua'] == nil) then
                            devShells['lua'] = 1;

                            require('nix-develop').nix_develop_extend({'${flakeEnv}#lua'}, function()
                                vim.cmd[[LspStart]];
                            end);
                        end
                    end,
                });

                require('lazydev').setup({
                    library = {
                        -- Load luvit types when the `vim.uv` word is found
                        { path = '${pkgs.vimPlugins.luvit-meta}/library', words = { 'vim%.uv' } },
                    },
                });

                require('lspconfig').lua_ls.setup({
                    capabilities = default_capabilities,
                    autostart = false,
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
