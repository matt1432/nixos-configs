{config, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/kmscon.nix
    ../../modules/tailscale.nix
  ];

  vars = {
    user = "matt";
    hostName = "servivi";
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
    resolvconf.enable = true;
    firewall.enable = false;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "24.05";
}
