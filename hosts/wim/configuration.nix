{ lib, hyprland, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/audio.nix
    ../../modules/kmscon.nix
    ../../modules/plymouth.nix
    ../../modules/printer.nix
    ../../modules/proton-bridge.nix
    ../../modules/sddm-wayland.nix

    ./cfg/main.nix
    ./home/main.nix
  ];

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "wim";
    networkmanager = {
      enable = true;
      wifi.backend = "wpa_supplicant";
    };
  };

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

  # List packages in root user PATH
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

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
