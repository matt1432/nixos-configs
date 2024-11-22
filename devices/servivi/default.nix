{
  config,
  self,
  ...
}: let
  inherit (config.vars) mainUser;
in {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    ./hardware-configuration.nix

    ./modules

    self.nixosModules.docker
    self.nixosModules.kmscon
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "24.05";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  vars = {
    mainUser = "matt";
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

  networking = {
    hostName = "servivi";
    resolvconf.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  roles.server = {
    user = mainUser;
    tailscale.enable = true;
    sshd.enable = true;
  };

  khepri.enable = true;
  services.kmscon.enable = true;

  home-manager.users.${mainUser} = {
    imports = [];

    programs.neovim = {
      enable = true;
      enableIde = true;
      user = mainUser;
    };
  };
}
