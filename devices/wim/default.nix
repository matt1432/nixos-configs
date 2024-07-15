{
  config,
  self,
  ...
}: let
  inherit (config.vars) mainUser hostName;
in {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    ./hardware-configuration.nix

    ../../modules/ags
    ../../modules/audio.nix
    ../../modules/kmscon.nix
    ../../modules/printer.nix
    ../../modules/tailscale.nix

    ./modules/security.nix

    self.nixosModules.adb
    self.nixosModules.desktop
    self.nixosModules.plymouth
  ];

  home-manager.users.${mainUser} = {
    imports = [
      ../../home/firefox
    ];

    # State Version: DO NOT CHANGE
    home.stateVersion = "23.05";
  };
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
      wifi.backend = "wpa_supplicant";
    };
    firewall.enable = false;
  };

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  roles.desktop = {
    user = mainUser;

    mainMonitor = "eDP-1";
    isLaptop = true;
    isTouchscreen = true;

    fontSize = 12.5;
  };

  programs.adb = {
    enable = true;
    user = mainUser;
  };

  boot.plymouth = {
    enable = true;
    theme = "dracula";
  };
}
