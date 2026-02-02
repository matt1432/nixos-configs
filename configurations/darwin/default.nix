{
  config,
  lib,
  mainUser,
  pkgs,
  self,
  ...
}: let
  inherit (lib) getExe;

  bashPkg = config.home-manager.users.${mainUser}.programs.bash.package;
in {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    self.nixosModules.base-darwin
    self.nixosModules.meta
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = 6;

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  users.users.${mainUser} = {
    home = "/Users/${mainUser}";
    shell = bashPkg;
  };

  programs.bash = {
    enable = true;
    completion.enable = true;
  };

  environment.variables.SHELL = getExe bashPkg;

  networking.hostName = "MGCOMP0192";

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  meta = {
    roleDescription = "Work Laptop";
    hardwareDescription = "MacBook Pro 16.1 2019";
  };

  roles.base = {
    enable = true;
    user = mainUser;
  };

  home-manager.users.${mainUser} = {
    imports = [
      self.homeManagerModules.firefox
      self.homeManagerModules.neovim
      self.homeManagerModules.shell
    ];

    # State Version: DO NOT CHANGE
    home.stateVersion = "25.11";

    home.packages = [
      pkgs.pnpm
      pkgs.yarn
    ];

    programs = {
      bash = {
        enable = true;
        enableNvm = true;
        promptMainColor = "purple";
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
