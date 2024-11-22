{
  config,
  self,
  pkgs,
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

    self.nixosModules.adb
    self.nixosModules.desktop
    self.nixosModules.docker
    self.nixosModules.kmscon
    self.nixosModules.plymouth
    self.nixosModules.server
  ];

  home-manager.users = rec {
    root = {
      imports = [
        self.homeManagerModules.firefox
        self.homeManagerModules.neovim
      ];

      programs.neovim = {
        enable = true;
        enableIde = true;
        user = mainUser;
      };
    };

    ${mainUser} = root;
  };

  # State Version: DO NOT CHANGE
  system.stateVersion = "23.05";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  vars = {
    mainUser = "matt";
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
    hostName = "wim";
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

    ags.enable = true;
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
      self.scopedPackages.${pkgs.system}.dracula.plymouth
    ];
  };

  khepri.enable = true;
  services.kmscon.enable = true;
}
