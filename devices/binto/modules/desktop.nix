{
  pkgs,
  config,
  ...
}: let
  hyprland =
    config
    .home-manager
    .users
    .${config.vars.user}
    .wayland
    .windowManager
    .hyprland
    .finalPackage;
in {
  programs.dconf.enable = true;

  services = {
    xserver = {
      displayManager = {
        sessionPackages = [hyprland];
      };

      libinput.enable = true;
    };

    greetd = {
      settings = {
        initial_session = {
          command = "${hyprland}/bin/Hyprland";
          user = config.vars.user;
        };
      };
    };

    dbus.enable = true;
    gvfs.enable = true;
    flatpak.enable = true;
  };

  programs.kdeconnect.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    qemu
    alsa-utils
    plasma5Packages.kio-admin
    plasma5Packages.ksshaskpass
    p7zip # for reshade
    kio-admin
  ];
}
