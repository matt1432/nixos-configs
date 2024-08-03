deviceName: {
  config,
  self,
  ...
}: let
  inherit (config.vars) mainUser hostName;

  clusterIP = config.services.pcsd.virtualIps.caddy-vip.ip;
in {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    ./hardware-configuration.nix

    ./modules/pcsd.nix

    self.nixosModules.kmscon
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "24.05";
  home-manager.users.${mainUser}.home.stateVersion = "24.05";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  vars = {
    mainUser = "matt";
    hostName = deviceName;
    promptMainColor =
      if deviceName == "thingone"
      then "green"
      else if deviceName == "thingtwo"
      then "red"
      else "purple";
  };

  users.users.${mainUser} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "adm"
    ];
  };

  networking = {
    inherit hostName;
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
}
