{
  config,
  lib,
  ...
}: {
  options.vars = let
    inherit (lib) mkOption types;
    flakeDir = config.environment.variables.FLAKE;
    cfg = config.vars;
  in {
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
      type = types.enum ["red" "green" "blue" "purple"];
      default = "purple";
    };

    promptColors = mkOption {
      description = ''
        Colors used in starship prompt
      '';

      default = import ./prompt-schemes.nix cfg.promptMainColor;

      # FIXME: doesn't work when passing vars to home-manager
      # readOnly = true;
      type = with types;
        submodule {
          options = {
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

    mainMonitor = mkOption {
      type = types.str;
      description = ''
        The name of the main monitor used for Hyprland
        and Regreet which also uses Hyprland
      '';
      # This is to allow a bash script to know whether this value exists
      default = "null";
    };

    greetdDupe = mkOption {
      type = types.bool;
      description = ''
        If we should duplicate regreet on all monitors
      '';
      default = true;
    };

    fontSize = mkOption {
      type = types.nullOr types.float;
    };

    neovimIde = mkOption {
      type = types.bool;
      default = true;
    };
  };
}
