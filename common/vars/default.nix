{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  flakeDir = config.environment.variables.FLAKE;
  cfg = config.vars;
in {
  options.vars = {
    mainUser = mkOption {
      type = types.str;
      description = ''
        Username that was defined at the initial setup process
      '';
    };

    hostName = mkOption {
      type = types.str;
      description = ''
        Hostname that was defined at the initial setup process
      '';
    };

    promptMainColor = mkOption {
      type = types.enum ["red" "green" "blue" "purple" "orange" "yellow" "cyan" "pink"];
      default = "purple";
    };

    promptColors = mkOption {
      description = ''
        Colors used in starship prompt
      '';

      default = import ./prompt-schemes.nix cfg.promptMainColor;

      readOnly = true;
      type = types.submodule {
        options = let
          inherit (types) str;
        in {
          textColor = mkOption {type = str;};
          firstColor = mkOption {type = str;};
          secondColor = mkOption {type = str;};
          thirdColor = mkOption {type = str;};
          fourthColor = mkOption {type = str;};
        };
      };
    };

    configDir = mkOption {
      type = types.str;
      default = "${flakeDir}/devices/${cfg.hostName}/config";
      description = ''
        The path to where most of the devices' configs are in the .nix folder
      '';
    };

    neovimIde = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = {
    environment.variables.FLAKE = lib.mkDefault "/home/${cfg.mainUser}/.nix";
  };
}
