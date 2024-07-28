{
  config,
  pkgs,
  lib,
  nixd,
  self,
  ...
}: let
  inherit (config.vars) hostName mainUser neovimIde;
  inherit (lib) getExe hasPrefix removePrefix;

  defaultFormat = self.formatter.${pkgs.system};

  nixdPkg = nixd.packages.${pkgs.system}.default;

  flakeEnv = config.programs.bash.sessionVariables.FLAKE;
  flakeDir = "${removePrefix "/home/${mainUser}/" flakeEnv}";
in
  lib.mkIf neovimIde {
    assertions = [
      {
        assertion =
          neovimIde
          && hasPrefix "/home/${mainUser}/" flakeEnv
          || !neovimIde;
        message = ''
          Your $FLAKE environment variable needs to point to a directory in
          the main users' home to use the neovim module.
        '';
      }
    ];

    home.packages = [
      defaultFormat
    ];

    xdg.dataFile."${flakeDir}/.nixd.json".text = builtins.toJSON {
      nixpkgs = {
        expr = "import (builtins.getFlake \"${flakeDir}\").inputs.nixpkgs {}";
      };
      options.nixos = {
        expr = "(builtins.getFlake \"${flakeDir}\").nixosConfigurations.${hostName}.options";
      };
    };

    programs = {
      neovim = {
        extraPackages = [
          nixdPkg
        ];

        extraLuaConfig =
          # lua
          ''
            require('lspconfig').nixd.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),

                filetypes = { 'nix', 'in.nix' },
                settings = {
                    nixd = {
                        formatting = {
                            -- TODO: Try to find <flake>.formatter
                            command = { '${getExe defaultFormat}' },
                        },
                    },
                },
            });
          '';
      };
    };
  }
