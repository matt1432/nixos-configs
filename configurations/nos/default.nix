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
    self.nixosModules.docker
    self.nixosModules.kmscon
    self.nixosModules.meta
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "24.05";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  users.users.${mainUser} = {
    isNormalUser = true;
    uid = 1000;

    hashedPassword = "$y$j9T$DSLWphPlpiahIw7KQciF1/$FOjIbplU1Fknv5W.A15Xgdk.WNXP.zeWkJiewSUTGPC";

    extraGroups = [
      "wheel"
      "adm"
      "borg"
    ];
  };

  networking = {
    hostName = "nos";
    resolvconf.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  meta = {
    roleDescription = "Custom built NAS and seedbox for Linux ISOs ;)";
    hardwareDescription = "NVIDIA 3060 with i5-3600";
  };

  roles.base = {
    enable = true;
    user = mainUser;
  };

  roles.server = {
    enable = true;
    user = mainUser;
    tailscale.enable = true;
    sshd.enable = true;
  };

  roles.docker.enable = true;

  services.kmscon.enable = true;

  home-manager.users.${mainUser} = {
    imports = [
      self.homeManagerModules.neovim
      self.homeManagerModules.shell
    ];

    programs = {
      bash = {
        enable = true;
        promptMainColor = "orange";
      };

      neovim = {
        enable = true;
        user = mainUser;
      };
    };
  };
}
