{config, ...}: {
  imports = [
    #./hardware-configuration.nix

    ../../modules/tailscale.nix

    ./modules/caddy.nix
    ./modules/headscale.nix
    ./modules/pihole.nix
    ./modules/unbound.nix
  ];

  vars = {
    user = "matt";
    hostName = "oksys";
  };

  users.users.${config.vars.user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "adm"
    ];
  };
  home-manager.users.${config.vars.user} = {
    imports = [];

    # No touchy
    home.stateVersion = "24.05";
  };

  networking = {
    networkmanager = {
      inherit (config.vars) hostName;
      enable = true;
      wifi.backend = "wpa_supplicant";
    };
    firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "24.05";
}
