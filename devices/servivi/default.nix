{config, ...}: {
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
    user = "matt";
    hostName = "servivi";
  };

  users.users = {
    ${config.vars.user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "adm"
      ];

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPE39uk52+NIDLdHeoSHIEsOUUFRzj06AGn09z4TUOYm matt@OP9"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICr2+CpqXNMLsjgbrYyIwTKhlVSiIYol1ghBPzLmUpKl matt@binto"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGbLu+Gb7PiyNgNXMHemaQLnKixebx1/4cdJGna9OQp matt@wim"
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

  home-manager.users.${config.vars.user} = {
    imports = [];

    # No touchy
    home.stateVersion = "24.05";
  };

  networking = {
    inherit (config.vars) hostName;
    resolvconf.enable = true;
    firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "24.05";
}
