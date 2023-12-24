{config, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/ags
    ../../modules/audio.nix
    ../../modules/hyprland
    ../../modules/kmscon.nix
    ../../modules/printer.nix
    ../../modules/proton-bridge.nix
    ../../modules/tailscale.nix

    ./modules/gpu-replay.nix
    ./modules/nix-gaming.nix
    ./modules/nvidia.nix
  ];

  vars = {
    user = "matt";
    hostName = "binto";
    mainMonitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D";
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

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPE39uk52+NIDLdHeoSHIEsOUUFRzj06AGn09z4TUOYm matt@OP9"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGbLu+Gb7PiyNgNXMHemaQLnKixebx1/4cdJGna9OQp matt@wim"
    ];
  };
  home-manager.users.${config.vars.user} = {
    imports = [
      ../../home/firefox

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
