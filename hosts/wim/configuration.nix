{ hyprland, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/audio.nix
    ../../modules/kmscon.nix
    ../../modules/plymouth.nix
    ../../modules/printer.nix
    ../../modules/proton-bridge.nix
    ../../modules/sddm-wayland.nix

    ./modules/security.nix
  ];

  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "uinput" "adm" "mlocate" "video" "libvirtd" ];
  };

  programs.dconf.enable = true;

  # TODO: use hm for tmux
  home-manager.users = {
    matt = {
      imports = [
        ./home/theme.nix
        ./home/hyprland.nix
        ./home/packages.nix

        ../../modules/alacritty.nix
        ../../modules/dconf.nix
        ../../modules/firefox
        ../../modules/wofi

        ./modules/dotfiles.nix
      ];

      # No touchy
      home.stateVersion = "23.05";
    };
  };

  networking = {
    hostName = "wim";
    networkmanager = {
      enable = true;
      wifi.backend = "wpa_supplicant";
    };
    firewall.enable = false;
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

  # No touchy
  system.stateVersion = "23.05";
}
