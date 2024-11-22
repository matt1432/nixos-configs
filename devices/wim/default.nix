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

    self.nixosModules.desktop
    self.nixosModules.docker
    self.nixosModules.kmscon
    self.nixosModules.plymouth
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "23.05";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  vars.mainUser = "matt";

  users.users.${mainUser} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "uinput"
      "adm"
      "video"
      "libvirtd"
      "adbusers"
    ];
  };

  programs.adb.enable = true;

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

  boot.plymouth = {
    enable = true;
    theme = "dracula";
    themePackages = [
      self.scopedPackages.${pkgs.system}.dracula.plymouth
    ];
  };

  khepri.enable = true;
  services.kmscon.enable = true;

  home-manager.users.${mainUser} = {
    imports = [
      self.homeManagerModules.firefox
      self.homeManagerModules.neovim
      self.homeManagerModules.shell
    ];

    programs = {
      bash = {
        enable = true;
        promptMainColor = "purple";
      };

      neovim = {
        enable = true;
        enableIde = true;
        user = mainUser;
      };
    };
  };
}
