{lib, ...}: {
  options.services.device-vars = with lib; {
    username = mkOption {
      description = ''
        Username that was defined at the initial setup process
      '';
      type = types.nullOr types.str;
    };

    configDir = mkOption {
      description = ''
        The path to where most of the devices' configs are in the .nix folder
      '';
      type = types.nullOr types.str;
    };

    mainMonitor = mkOption {
      description = ''
        The name of the main monitor used for Hyprland and Regreet
      '';
      default = "null";
      type = types.nullOr types.str;
    };

    greetdDupe = mkOption {
      description = ''
        If we should duplicate regreet on all monitors
      '';
      default = true;
      type = types.nullOr types.bool;
    };

    fontSize = mkOption {
      type = types.nullOr types.float;
    };
  };
}
