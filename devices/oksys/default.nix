{...}: {
  imports = [
    #./hardware-configuration.nix

    ../../modules/tailscale.nix

    ./modules/headscale.nix
  ];

  services.device-vars = {
    username = "matt";
  };

  users.users.matt = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "adm"
      "mlocate"
      "headscale"
    ];
  };
  home-manager.users = {
    matt = {
      imports = [];

      # No touchy
      home.stateVersion = "24.05";
    };
  };

  networking = {
    hostName = "oksys";
    networkmanager = {
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
