{config, ...}: let
  inherit (config.vars) mainUser hostName;
in {
  imports = [
    ./hardware-configuration.nix

    ../../modules/android.nix
    ../../modules/ags
    ../../modules/audio.nix
    ../../modules/hyprland
    ../../modules/kmscon.nix
    ../../modules/plymouth.nix
    ../../modules/printer.nix
    ../../modules/tailscale.nix

    ./modules/security.nix
  ];

  vars = {
    mainUser = "matt";
    hostName = "wim";
    promptMainColor = "purple";
    fontSize = 12.5;
    mainMonitor = "eDP-1";
  };

  users.users.${mainUser} = {
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
  home-manager.users.${mainUser} = {
    imports = [
      ../../home/firefox

      ./home/packages.nix
    ];

    # No touchy
    home.stateVersion = "23.05";
  };

  networking = {
    inherit hostName;
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
