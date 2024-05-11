{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (pkgs) vimPlugins;

  flakeEnv = config.programs.bash.sessionVariables.FLAKE;
in
  lib.mkIf neovimIde {
    programs = {
      neovim = {
        extraPackages = [
          pkgs.lua-language-server
        ];

        plugins = [
          {
            plugin = vimPlugins.neodev-nvim;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
                require("neodev").setup({
                    override = function(root_dir, library)
                        if root_dir:find('${flakeEnv}', 1, true) == 1 then
                            library.enabled = true
                            library.plugins = true
                        end
                    end,
                });

                require('lspconfig').lua_ls.setup(
                    require('coq').lsp_ensure_capabilities({}));
              '';
          }
        ];
      };
    };
  }
