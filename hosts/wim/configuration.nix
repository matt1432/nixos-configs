{ ... }: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/audio.nix
    ../../modules/kmscon.nix
    ../../modules/plymouth.nix
    ../../modules/printer.nix
    ../../modules/proton-bridge.nix
    ../../modules/sddm-wayland.nix

    ./modules/desktop.nix
    ./modules/security.nix
  ];

  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "uinput" "adm" "mlocate" "video" "libvirtd" ];
  };
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

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "23.05";
}
