{config, ...}: let
  inherit (config.vars) mainUser hostName;
in {
  imports = [
    ./hardware-configuration.nix

    ../../modules/kmscon.nix
    ../../modules/sshd.nix
    ../../modules/tailscale.nix

    ./modules/arion
    ./modules/jellyfin
    ./modules/mergerfs.nix
    ./modules/qbittorrent
    ./modules/snapraid.nix
  ];

  vars = {
    mainUser = "matt";
    hostName = "nos";
    #promptMainColor = "?";
  };

  users.users.${mainUser} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "adm"
        "borg"
      ];
  };

  home-manager.users.${mainUser} = {
    imports = [];

    # No touchy
    home.stateVersion = "24.05";
  };

  networking = {
    inherit hostName;
    resolvconf.enable = true;
    firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "24.05";
}
