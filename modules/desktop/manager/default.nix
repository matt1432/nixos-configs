self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkIf optionalString;

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

  keyringPassFile = config.sops.secrets.binto-keyring.path or "null";

  autoLoginKeyringFix =
    # bash
    ''
      # Wait for keyring control socket to be available (up to 5 seconds)
      # shellcheck disable=SC2034
      for i in $(seq 1 10); do
          [ -S "$XDG_RUNTIME_DIR/keyring/control" ] && break
          sleep 0.5
      done

      # Check if keyring control socket exists
      if [ ! -S "$XDG_RUNTIME_DIR/keyring/control" ]; then
          echo "Keyring control socket not found after waiting, keyring may not be running" >&2
          exit 1
      fi

      # Read the password from the agenix secret and unlock
      if [ -f "${keyringPassFile}" ]; then
          /run/wrappers/bin/gnome-keyring-daemon \
              --daemonize \
              --replace \
              --unlock \
              --components=secrets < "${keyringPassFile}" &> /tmp/gkd.log
      else
          echo "Keyring password file not found: ${keyringPassFile}" >&2
          exit 1
      fi
    '';
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

                ${optionalString (keyringPassFile != "null") autoLoginKeyringFix}

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
