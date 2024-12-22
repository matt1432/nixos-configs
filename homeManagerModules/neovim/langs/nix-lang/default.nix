self: {
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (builtins) toJSON;
  inherit (lib) attrValues getExe hasPrefix mkIf removePrefix;
  inherit (osConfig.networking) hostName;

  cfg = config.programs.neovim;

  defaultFormatter = self.formatter.${pkgs.system};

  nixdPkg = self.inputs.nixd.packages.${pkgs.system}.default;

  flakeEnv = config.programs.bash.sessionVariables.FLAKE;
  flakeDir = "${removePrefix "/home/${cfg.user}/" flakeEnv}";
in {
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hasPrefix "/home/${cfg.user}/" flakeEnv;
        message = ''
          Your $FLAKE environment variable needs to point to a directory in
          the main users' home to use the neovim module.
        '';
      }
    ];

    home.packages = attrValues {
      inherit
        defaultFormatter
        nixdPkg
        ;
    };

    # nixd by default kinda spams LspLog
    home.sessionVariables.NIXD_FLAGS = "-log=error";

    xdg.dataFile."${flakeDir}/.nixd.json".text = toJSON {
      nixpkgs = {
        expr = "import (builtins.getFlake \"${flakeDir}\").inputs.nixpkgs {}";
      };
      options.nixos = {
        expr = "(builtins.getFlake \"${flakeDir}\").nixosConfigurations.${hostName}.options";
      };
    };

    programs = {
      neovim = {
        extraPackages = attrValues {
          inherit nixdPkg;
        };

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
                            command = { '${getExe defaultFormatter}' },
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
