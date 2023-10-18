{ ... }: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/audio.nix
    ../../modules/kmscon.nix
    ../../modules/printer.nix

    ./modules/desktop.nix
    ./modules/nix-gaming.nix
    ./modules/nvidia.nix
  ];

  services.hostvars = {
    username = "matt";
    fontSize = 10.0;
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
        ../../modules/alacritty.nix
        ../../modules/dconf.nix
        ../../modules/firefox
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

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # No touchy
  system.stateVersion = "23.11";
}
