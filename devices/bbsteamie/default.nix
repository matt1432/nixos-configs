{
  config,
  pkgs,
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

    ./modules/desktop

    self.nixosModules.kmscon
    self.nixosModules.plymouth
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "24.11";
  home-manager.users.${mainUser}.home.stateVersion = "24.11";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  vars = {
    mainUser = "mariah";
    hostName = "bbsteamie";
    promptMainColor = "pink";
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
    networkmanager.enable = true;
  };

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  roles.server = {
    user = mainUser;
    sshd.enable = true;
  };

  boot.plymouth = {
    enable = true;
    theme = "steamos";
    themePackages = [pkgs.steamdeck-hw-theme];
  };

  services.kmscon.enable = true;
}
