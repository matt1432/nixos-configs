{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enableIde {
    programs = {
      neovim = {
        withPython3 = true;

        extraPython3Packages = py:
          (attrValues {
            inherit (py) python-lsp-server;
          })
          ++ py.python-lsp-server.optional-dependencies.all;

        extraPackages =
          (attrValues {
            inherit (pkgs.python3Packages) python-lsp-server;
          })
          ++ pkgs.python3Packages.python-lsp-server.optional-dependencies.all;

        extraLuaConfig =
          # lua
          ''
            require('lspconfig').pylsp.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),

                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                maxLineLength = 100,
                            },
                        },
                    },
                },
            });
          '';
      };
    };
  };
}
