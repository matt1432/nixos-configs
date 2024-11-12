self: {
  config,
  lib,
  ...
}: let
  inherit (lib) elemAt mkOption types;

  inherit (self.inputs) home-manager;

  cfg = config.roles.desktop;
  flakeDir = config.environment.variables.FLAKE;
in {
  imports = [
    (import ./manager self)
    (import ./environment self)

    self.nixosModules.nvidia
    home-manager.nixosModules.home-manager
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

    ags-v2.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether we want to enable AGSv2 for the DE shell.
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

    fontName = mkOption {
      type = types.str;
      default = elemAt config.fonts.fontconfig.defaultFonts.monospace 0;
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
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether we want to enable the Display Manager.
        '';
      };

      duplicateScreen = mkOption {
        type = types.bool;
        description = ''
          If we should duplicate the login prompt on all monitors.
        '';
        default = true;
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
