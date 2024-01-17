{config, ...}: let
  inherit (config.vars) mainUser hostName;
in {
  imports = [
    ./hardware-configuration.nix

    ../../modules/kmscon.nix
    ../../modules/sshd.nix
    ../../modules/tailscale.nix

    ./modules/arion
    ./modules/binary-cache.nix
    ./modules/borgbackup.nix
    ./modules/minecraft.nix
  ];

  vars = {
    mainUser = "matt";
    hostName = "servivi";
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOujvC5JLnyjqD1bzl/H0256Gxw/biu7spIHy3YJiDL root@oksys"
      ];
    };
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
