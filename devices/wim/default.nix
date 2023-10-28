{ ... }: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/audio.nix
    ../../modules/greetd
    ../../modules/kmscon.nix
    ../../modules/plymouth.nix
    ../../modules/printer.nix
    ../../modules/proton-bridge.nix
    ../../modules/tailscale.nix

    ./modules/desktop.nix
    ./modules/security.nix
  ];

  services.device-vars = {
    username = "matt";
    configDir = "/home/matt/.nix/devices/wim/config";
    fontSize = 12.5;
  };

  users.users.matt = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "uinput"
      "adm"
      "mlocate"
      "video"
      "libvirtd"
    ];
  };
  home-manager.users = {
    matt = {
      imports = [
        ../../home/alacritty.nix
        ../../home/dconf.nix
        ../../home/firefox
        ../../home/theme.nix
        ../../home/wofi

        ./home/dotfiles.nix
        ./home/packages.nix
        ./home/hyprland.nix
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
