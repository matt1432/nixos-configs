{ ... }: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/audio.nix
    ../../modules/kmscon.nix
    ../../modules/printer.nix
    ../../modules/tailscale.nix

    ./modules/desktop.nix
    ./modules/nix-gaming.nix
    ./modules/nvidia.nix
  ];

  services.device-vars = {
    username = "matt";
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
      ];

      # No touchy
      home.stateVersion = "23.11";
    };
  };

  networking = {
    hostName = "binto";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # No touchy
  system.stateVersion = "23.11";
}
