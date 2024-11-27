{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.neovim;
in
  mkIf cfg.enableIde {
    programs = {
      neovim = {
        withPython3 = true;

        extraPython3Packages = py:
          with py; ([
              python-lsp-server
            ]
            ++ python-lsp-server.optional-dependencies.all);

        extraPackages = with pkgs.python3Packages; ([
            python-lsp-server
          ]
          ++ python-lsp-server.optional-dependencies.all);

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
  }
