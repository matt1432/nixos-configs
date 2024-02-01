deviceName: {config, ...}: let
  inherit (config.vars) mainUser hostName;

  clusterIP = config.services.pcsd.virtualIps.caddy-vip.ip;
in {
  imports = [
    ./hardware-configuration.nix

    ../../modules/kmscon.nix
    ../../modules/sshd.nix
    ../../modules/tailscale.nix

    ./modules/pcsd.nix
  ];

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

  home-manager.users.${mainUser} = {
    imports = [];

    # No touchy
    home.stateVersion = "24.05";
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

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "24.05";
}
