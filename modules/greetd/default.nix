{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;
  inherit (import ./hyprland.nix {inherit config lib pkgs;}) hyprConf;

  # Nix stuff
  isTouchscreen = config.hardware.sensor.iio.enable;
  hyprland = config.home-manager.users.${mainUser}.wayland.windowManager.hyprland.finalPackage;
in {
  imports = [./astal.nix];

  services = {
    displayManager = {
      sessionPackages = [hyprland];
    };

    xserver = {
      libinput.enable = true;
      wacom.enable = isTouchscreen;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "Hyprland --config ${hyprConf}";
          user = "greeter";
        };

        initial_session = {
          command = "Hyprland";
          user = mainUser;
        };
      };
    };
  };

  # unlock GPG keyring on login
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
