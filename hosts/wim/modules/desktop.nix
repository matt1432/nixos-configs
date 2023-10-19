{ hyprland, pkgs, ... }: {
  programs.dconf.enable = true;

  services = {
    xserver = {
      displayManager = {
        sessionPackages = [
          hyprland.packages.x86_64-linux.default
        ];
      };

      libinput.enable = true;
    };

    greetd = {
      settings = {
        initial_session = {
          command = "${hyprland.packages.x86_64-linux.default}/bin/Hyprland";
          user = "matt";
        };
      };
    };

    dbus.enable = true;
    gvfs.enable = true;
    flatpak.enable = true;
    tlp.enable = true;
  };

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
