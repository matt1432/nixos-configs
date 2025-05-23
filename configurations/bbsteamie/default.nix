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
    self.nixosModules.meta
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
    uid = 1000;

    hashedPassword = "$y$j9T$b6YdvHx1b/HOD6Kt3Tw1W.$yIy5Km1xBViJA2kra9l38S/0auhEHPdXOMb6RBhgxID";

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
  meta = {
    roleDescription = "My wife's SteamDeck that has a pink case (it took a lot of convincing for this)";
    hardwareDescription = "512GB OLED";
  };

  roles.base = {
    enable = true;
    user = mainUser;
  };

  roles.server = {
    enable = true;
    user = mainUser;
    sshd.enable = true;
  };

  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

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
