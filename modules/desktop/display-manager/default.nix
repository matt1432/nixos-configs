{config, ...}: let
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
    ./astal.nix
    ./hyprland.nix
  ];

  services = {
    displayManager.sessionPackages = [hyprland];

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "Hyprland";
          user = "greeter";
        };

        initial_session = {
          command = "Hyprland";
          user = cfg.user;
        };
      };
    };
  };

  # unlock GPG keyring on login
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
