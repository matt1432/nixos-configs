{
  pkgs,
  config,
  ...
}:  let
  user = config.services.device-vars.username;
  hyprland = config.home-manager.users.${user}.wayland.windowManager.hyprland.finalPackage;
in {
  programs.dconf.enable = true;

  services = {
    xserver = {
      displayManager = {
        sessionPackages = [hyprland];
      };

      libinput.enable = true;
      wacom.enable = true;
    };

    greetd = {
      settings = {
        initial_session = {
          command = "${hyprland}/bin/Hyprland";
          user = "matt";
        };
      };
    };

    dbus.enable = true;
    gvfs.enable = true;
    flatpak.enable = true;
    tlp.enable = true;
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
    # for sddm
    plasma5Packages.plasma-framework
    plasma5Packages.plasma-workspace

    qemu
    wl-clipboard
    alsa-utils
    evtest
    plasma5Packages.kio-admin
    plasma5Packages.ksshaskpass
  ];
}
