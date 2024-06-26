{
  config,
  lib,
  self,
  ...
}: let
  inherit (lib) types;
  inherit (lib.options) mkOption;

  cfg = config.roles.desktop;
  flakeDir = config.environment.variables.FLAKE;
in {
  imports = [
    ./display-manager
    ./desktop-environment

    self.nixosModules.nvidia
  ];

  config.assertions = [
    {
      assertion = lib.hasPrefix "/home/${cfg.user}/" flakeDir;
      message = ''
        Your $FLAKE environment variable needs to point to a directory in
        the main users' home to use the desktop module.
      '';
    }
  ];

  options.roles.desktop = {
    user = mkOption {
      type = types.str;
      description = ''
        The name of the user who is going to be using the "DE".
      '';
    };

    mainMonitor = mkOption {
      type = types.str;
      description = ''
        The name of the main monitor used for Hyprland
        and Greetd which also uses Hyprland.
      '';
      # This is to allow a bash script to know whether this value exists
      default = "null";
    };

    fontSize = mkOption {
      type = types.float;
      default = 12.0;
      description = ''
        The size of the font in GUIs.
      '';
    };

    isLaptop = mkOption {
      type = types.bool;
      description = ''
        If the computer is a laptop.
      '';
      default = false;
    };

    isTouchscreen = mkOption {
      type = types.bool;
      description = ''
        If the computer has a touchscreen.
      '';
      default = false;
    };

    displayManager = {
      duplicateScreen = mkOption {
        type = types.bool;
        description = ''
          If we should duplicate the login prompt on all monitors.
        '';
        default = true;
      };
    };
  };
}
