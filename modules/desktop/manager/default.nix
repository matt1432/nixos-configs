self: {
  config,
  lib,
  pkgs,
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

  hyprlandExe = "${hyprland}/bin/Hyprland";
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
            command = getExe (pkgs.writeShellApplication {
              name = "hyprland-session";
              text = ''
                export XDG_RUNTIME_DIR="/run/user/$UID"

                # Clear the terminal to prevent visual artifacts
                clear

                exec ${hyprlandExe}
              '';
            });
            user = "greeter";
          };

          initial_session = {
            command = getExe (pkgs.writeShellApplication {
              name = "hyprland-session";
              text = ''
                export XDG_RUNTIME_DIR="/run/user/$UID"

                # Start gnome-keyring-daemon
                # PAM will automatically unlock the login keyring if configured correctly
                # shellcheck disable=SC2046
                eval $(/run/wrappers/bin/gnome-keyring-daemon --start --components=secrets)
                export GNOME_KEYRING_CONTROL

                # Clear the terminal to prevent visual artifacts
                clear

                exec ${hyprlandExe}
              '';
            });
            user = cfg.user;
          };
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
