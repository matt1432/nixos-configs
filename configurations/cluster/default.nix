deviceName: {
  config,
  mainUser,
  self,
  ...
}: let
  clusterIP = (builtins.head config.services.pcsd.virtualIps).ip;
in {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    ./hardware-configuration.nix

    ./modules

    self.nixosModules.base
    self.nixosModules.kmscon
    self.nixosModules.meta
    self.nixosModules.server
  ];

  config = {
    # State Version: DO NOT CHANGE
    system.stateVersion = "24.05";

    # ------------------------------------------------
    # User Settings
    # ------------------------------------------------
    users.users.${mainUser} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "adm"
      ];
    };

    networking = {
      hostName = deviceName;
      resolvconf.enable = true;
      nameservers = [
        clusterIP
        "1.0.0.1"
      ];
      extraHosts = ''
        10.0.0.244 thingone
        10.0.0.159 thingtwo
      '';
      firewall.enable = false;
    };

    time.timeZone = "America/Montreal";

    # ------------------------------------------------
    # `Self` Modules configuration
    # ------------------------------------------------
    meta = {
      roleDescription = ''
        Mini PC that makes use of [NixOS-pcsd](https://github.com/matt1432/nixos-pcsd)
        to form a cluster with its twin. Files located in `cluster`
      '';
      hardwareDescription = "Lenovo ThinkCentre M900";
    };

    roles.base = {
      enable = true;
      user = mainUser;
    };

    roles.server = {
      enable = true;
      user = mainUser;
      tailscale.enable = true;
      sshd.enable = true;
    };

    services.kmscon.enable = true;

    home-manager.users.${mainUser} = {
      imports = [
        self.homeManagerModules.neovim
        self.homeManagerModules.shell
      ];

      programs = {
        bash = {
          enable = true;
          promptMainColor =
            if deviceName == "thingone"
            then "green"
            else if deviceName == "thingtwo"
            then "red"
            else "purple";
        };

        neovim = {
          enable = true;
          user = mainUser;
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
