{
  config,
  self,
  ...
}: let
  inherit (config.vars) mainUser hostName;
in {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    ./hardware-configuration.nix

    ../../modules/kmscon.nix
    ../../modules/sshd.nix
    ../../modules/tailscale.nix

    ./modules/docker
    ./modules/jellyfin
    ./modules/mergerfs.nix
    ./modules/qbittorrent
    ./modules/snapraid.nix
    ./modules/subtitles

    self.nixosModules.docker
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "24.05";
  home-manager.users.${mainUser}.home.stateVersion = "24.05";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  vars = {
    mainUser = "matt";
    hostName = "nos";
    promptMainColor = "orange";
  };

  users.users.${mainUser} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "adm"
      "borg"
    ];
  };

  networking = {
    inherit hostName;
    resolvconf.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "America/Montreal";
}
