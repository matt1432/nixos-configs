self: {
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) getExe hasPrefix mkIf;
  inherit (osConfig.networking) hostName;

  cfg = config.programs.neovim;
  mainHmCfg = osConfig.home-manager.users.${cfg.user} or config;

  defaultFormatter = self.formatter.${pkgs.stdenv.hostPlatform.system};
  formatCmd = pkgs.writeShellApplication {
    name = "nix-fmt-cmd";
    runtimeInputs = with pkgs; [jq];
    text = ''
      if info="$(nix flake show --json 2> /dev/null)" && [[ "$(jq -r .formatter <<< "$info")" != "null" ]]; then
          exec nix fmt -- --
      else
          exec ${getExe defaultFormatter}
      fi
    '';
  };

  nixdPkg = pkgs.nixd;

  flakeEnv = config.programs.bash.sessionVariables.FLAKE;

  getFlake = "(builtins.getFlake \"${flakeEnv}\")";

  optionsAttr =
    if osConfig != null
    then "nixosConfigurations.${hostName}.options"
    else "nixOnDroidConfigurations.default.options";

  homeOptionsAttr =
    if osConfig != null
    then "${optionsAttr}.home-manager.users.type.getSubOptions []"
    else "${optionsAttr}.home-manager";
in {
  config = mkIf (cfg.enable && cfg.ideConfig.enableNix) {
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

    programs = {
      neovim = {
        extraPackages = attrValues {
          inherit nixdPkg;
        };

        initLua =
          # lua
          ''
            vim.lsp.enable('nixd');
            vim.lsp.config('nixd', {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),

                filetypes = { 'nix', 'in.nix' },
                settings = {
                    nixd = {
                        nixpkgs = {
                            expr = 'import ${getFlake}.inputs.nixpkgs {}',
                        },
                        formatting = {
                            command = { '${getExe formatCmd}' },
                        },
                        options = {
                            nixos = {
                                expr = '${getFlake}.${optionsAttr}',
                            },
                            home_manager = {
                                expr = '${getFlake}.${homeOptionsAttr}',
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
