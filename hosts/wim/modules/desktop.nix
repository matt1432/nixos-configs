{ hyprland, pkgs, ... }: {
  programs.dconf.enable = true;

  services = {
    xserver = {
      displayManager = {
        sessionPackages = [
          hyprland.packages.x86_64-linux.default
        ];
        defaultSession = "hyprland";

        autoLogin = {
          enable = true;
          user = "matt";
        };
      };

      libinput.enable = true;
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
