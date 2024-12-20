{
  mainUser,
  self,
  ...
}: {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    ./hardware-configuration.nix

    ./modules

    self.nixosModules.base
    self.nixosModules.kmscon
    self.nixosModules.plymouth
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "24.11";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  users.users.${mainUser} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "adm"
    ];
  };

  networking = {
    hostName = "bbsteamie";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  roles.base = {
    enable = true;
    user = mainUser;
  };

  roles.server = {
    user = mainUser;
    sshd.enable = true;
  };

  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  services.kmscon.enable = true;

  home-manager.users.${mainUser} = {
    imports = [
      self.homeManagerModules.shell
    ];

    programs = {
      bash = {
        enable = true;
        promptMainColor = "pink";
      };
    };
  };
}
