self: {
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.roles.desktop;

  hyprland =
    config
    .home-manager
    .users
    .${cfg.user}
    .wayland
    .windowManager
    .hyprland
    .finalPackage;

  hyprlandExe = "${hyprland}/bin/start-hyprland --";
in {
  imports = [
    (import ./ags self)
    (import ./hyprland self)
  ];

  config = mkIf (cfg.enable && cfg.displayManager.enable) {
    services = {
      displayManager.sessionPackages = [hyprland];

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = hyprlandExe;
            user = "greeter";
          };

          initial_session = {
            command = hyprlandExe;
            user = cfg.user;
          };
        };
      };
    };

    # unlock GPG keyring on login
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
  };

  # For accurate stack trace
  _file = ./default.nix;
}
