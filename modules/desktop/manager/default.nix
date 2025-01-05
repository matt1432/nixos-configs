self: {
  config,
  lib,
  pkgs,
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

  # Hide TTY on launch
  cmd = toString (pkgs.writeShellScript "hyprland-wrapper" ''
    trap 'systemctl --user stop hyprland-session.target; sleep 1' EXIT
    exec Hyprland >/dev/null
  '');
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
            command = cmd;
            user = "greeter";
          };

          initial_session = {
            command = cmd;
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
