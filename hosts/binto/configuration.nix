{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/audio.nix
    ../../modules/kmscon.nix
    ../../modules/printer.nix

    ./modules/nvidia.nix
    ./modules/nix-gaming.nix
  ];

  networking = {
    hostName = "binto";
    networkmanager.enable = true;
    firewall.enable = false;
  };
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Enable the KDE Plasma Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  services = {
    dbus.enable = true;
    gvfs.enable = true;
    flatpak.enable = true;

    tailscale = {
      enable = true;
      extraUpFlags = [
        "--login-server https://headscale.nelim.org"
        "--operator=matt"
      ];
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    p7zip # for reshade
    xclip
  ];

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    oxygen
    khelpcenter
    konsole
    plasma-browser-integration
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
        ../../modules/alacritty.nix
        ../../modules/dconf.nix
        ../../modules/firefox
      ];
      programs.alacritty.settings.font.size = 10;

      home.stateVersion = "23.11";
    };
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
