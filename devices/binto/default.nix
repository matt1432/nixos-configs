{config, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/ags
    ../../modules/audio.nix
    ../../modules/greetd
    ../../modules/kmscon.nix
    ../../modules/printer.nix
    ../../modules/proton-bridge.nix
    ../../modules/tailscale.nix

    ./modules/desktop.nix
    ./modules/gpu-replay.nix
    ./modules/nix-gaming.nix
    ./modules/nvidia.nix
  ];

  vars = {
    user = "matt";
    hostName = "binto";
    mainMonitor = "DP-5";
    greetdDupe = false;
    fontSize = 12.5;
  };

  users.users.${config.vars.user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "uinput"
      "adm"
      "video"
      "libvirtd"
    ];
  };
  home-manager.users.${config.vars.user} = {
    imports = [
      ../../home/dconf.nix
      ../../home/firefox
      ../../home/hyprland

      ./home/packages.nix
    ];

    # No touchy
    home.stateVersion = "23.11";
  };

  networking = {
    inherit (config.vars) hostName;
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
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "23.11";
}
