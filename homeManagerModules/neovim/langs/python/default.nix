{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.programs.neovim;

  # We keep the packages here because python is a bit complicated and common
  pythonPkgs = p:
    (attrValues {
      inherit
        (p)
        python-lsp-server
        pyls-isort
        pylsp-mypy
        python-lsp-ruff
        python-lsp-jsonrpc
        ;
    })
    ++ p.python-lsp-server.optional-dependencies.all;
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
                            -- auto-completion options
                            jedi_completion = {
                                fuzzy = true,
                            },

                            -- import sorting
                            pyls_isort = {
                                enabled = true,
                            },

                            -- type checker
                            pylsp_mypy = {
                                enabled = true,
                            },

                            -- linter
                            ruff = {
                                enabled = true,
                                formatEnabled = true,
                                lineLength = 100,
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
