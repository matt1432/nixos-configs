{config, ...}: let
  inherit (config.vars) mainUser hostName;
in {
  imports = [
    ./hardware-configuration.nix

    ../../modules/arion
    ../../modules/kmscon.nix
    ../../modules/sshd.nix
    ../../modules/tailscale.nix

    ./modules/7-days-to-die.nix
    ./modules/binary-cache.nix
    ./modules/minecraft.nix
    ./modules/nfs.nix
  ];

  vars = {
    mainUser = "matt";
    hostName = "servivi";
    promptMainColor = "blue";
  };

  users.users = {
    ${mainUser} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "adm"
      ];
    };

    # https://nixos.wiki/wiki/Distributed_build
    nixremote = {
      isNormalUser = true;
      createHome = true;
      home = "/var/lib/nixremote";
      homeMode = "500";

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOujvC5JLnyjqD1bzl/H0256Gxw/biu7spIHy3YJiDL"
      ];
    };
  };

  home-manager.users.${mainUser} = {
    imports = [];

    # No touchy
    home.stateVersion = "24.05";
  };

  arion.enable = true;

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
