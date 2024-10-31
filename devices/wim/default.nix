{
  config,
  self,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser hostName;
in {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    ./hardware-configuration.nix

    ./modules

    self.nixosModules.adb
    self.nixosModules.desktop
    self.nixosModules.docker
    self.nixosModules.kmscon
    self.nixosModules.plymouth
    self.nixosModules.server
  ];

  home-manager.users.${mainUser}.imports = [
    self.homeManagerModules.firefox
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "23.05";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  vars = {
    mainUser = "matt";
    hostName = "wim";
    promptMainColor = "purple";
  };

  users.users.${mainUser} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "uinput"
      "adm"
      "video"
      "libvirtd"
    ];
  };

  networking = {
    inherit hostName;
    networkmanager = {
      enable = true;

      wifi = {
        backend = "wpa_supplicant";
        scanRandMacAddress = false;
      };
    };
    firewall.enable = false;
  };

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  roles.desktop = {
    user = mainUser;

    ags-v2.enable = true;
    mainMonitor = "eDP-1";
    isLaptop = true;
    isTouchscreen = true;

    fontSize = 12.5;
  };

  roles.server = {
    user = mainUser;
    tailscale.enable = true;
  };

  programs.adb = {
    enable = true;
    user = mainUser;
  };

  boot.plymouth = {
    enable = true;
    theme = "dracula";
    themePackages = [
      self.legacyPackages.${pkgs.system}.dracula.plymouth
    ];
  };

  khepri.enable = true;
  services.kmscon.enable = true;
}
