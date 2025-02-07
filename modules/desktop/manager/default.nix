self: {
  config,
  lib,
  ...
}: let
  inherit (lib) getExe mkIf;

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
            command = getExe hyprland;
            user = "greeter";
          };

          initial_session = {
            command = getExe hyprland;
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
