{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.programs.neovim;

  # We keep the packages here because python is a bit complicated and common
  pythonPkgs = py:
    (attrValues {
      inherit (py) python-lsp-server;
    })
    ++ py.python-lsp-server.optional-dependencies.all;
in {
  config = mkIf (cfg.enable && cfg.ideConfig.enablePython) {
    programs = {
      neovim = {
        withPython3 = true;

        extraPython3Packages = pythonPkgs;
        extraPackages = pythonPkgs pkgs.python3Packages;

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

  # For accurate stack trace
  _file = ./default.nix;
}
