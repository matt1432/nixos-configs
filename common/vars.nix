{
  config,
  lib,
  ...
}: {
  options.vars = with lib; {
    user = mkOption {
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

    configDir = mkOption {
      type = types.str;
      default = "/home/${config.vars.user}/.nix/devices/${config.vars.hostName}/config";
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
      default = "null";
    };

    greetdDupe = mkOption {
      type = types.nullOr types.bool;
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
