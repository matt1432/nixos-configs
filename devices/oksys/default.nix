{config, ...}: {
  imports = [
    #./hardware-configuration.nix

    ../../modules/tailscale.nix

    ./modules/blocky.nix
    ./modules/caddy.nix
    ./modules/headscale.nix
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
    inherit (config.vars) hostName;
    resolvconf = {
      enable = true;
      extraConfig = ''
        name_servers='1.0.0.1'
      '';
    };
    firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "24.05";
}
