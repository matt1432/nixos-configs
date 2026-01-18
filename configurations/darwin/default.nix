{
  mainUser,
  pkgs,
  self,
  ...
}: {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    # self.nixosModules.base
    self.nixosModules.meta
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = 6;

  # TODO: remove this
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  users.users.${mainUser}.home = "/Users/${mainUser}";

  networking.hostName = "MGCOMP0192";

  /*
  time.timeZone = "America/Montreal";
  */

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  meta = {
    roleDescription = "Work Laptop";
    hardwareDescription = "MacBook Pro 16.1 2019";
  };

  /*
  roles.base = {
    enable = true;
    user = mainUser;
  };
  */

  home-manager.users.${mainUser} = {
    imports = [
      self.homeManagerModules.firefox
      self.homeManagerModules.neovim
      self.homeManagerModules.shell
    ];

    home.stateVersion = "25.11";

    home.packages = [
      pkgs.wget
      pkgs.selfPackages.pokemon-colorscripts
      pkgs.pnpm
      pkgs.yarn
    ];

    programs = {
      bash = {
        enable = true;
        enableNvm = true;
        promptMainColor = "purple";

        sessionVariables.FLAKE = "/Users/${mainUser}/.nix";
      };

      firefox.enableCustomConf = true;

      neovim = {
        enable = true;
        user = mainUser;
      };

      ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
      };
    };
  };
}
