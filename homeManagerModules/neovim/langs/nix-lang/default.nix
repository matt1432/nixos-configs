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
  mainHmCfg = osConfig.home-manager.users.${cfg.user} or config;

  defaultFormatter = self.formatter.${pkgs.system};

  nixdPkg = self.inputs.nixd.packages.${pkgs.system}.default;

  flakeEnv = config.programs.bash.sessionVariables.FLAKE;
  flakeDir = "${removePrefix "${mainHmCfg.home.homeDirectory}/" flakeEnv}";
  optionsAttr =
    if osConfig != null
    then "nixosConfigurations.${hostName}.options"
    else "nixOnDroidConfigurations.default";
in {
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hasPrefix "${mainHmCfg.home.homeDirectory}/" flakeEnv;
        message = ''
          Your $FLAKE environment variable needs to point to a directory in
          the main users' home to use the neovim module.
        '';
      }
    ];

    # We keep the packages here
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
        expr = "(builtins.getFlake \"${flakeDir}\").${optionsAttr}";
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
