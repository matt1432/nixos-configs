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

    ../../modules/kmscon.nix
    ../../modules/sshd.nix

    ./modules/desktop

    self.nixosModules.plymouth
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
  boot.plymouth = {
    enable = true;
    theme = "steamos";
  };
}
