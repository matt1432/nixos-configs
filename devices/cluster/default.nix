deviceName: {
  config,
  self,
  ...
}: let
  inherit (config.vars) mainUser;

  clusterIP = config.services.pcsd.virtualIps.caddy-vip.ip;
in {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    ./hardware-configuration.nix

    ./modules

    self.nixosModules.kmscon
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "24.05";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  vars.mainUser = "matt";

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
  roles.server = {
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
        enableIde = true;
        user = mainUser;
      };
    };
  };
}
