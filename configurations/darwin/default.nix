{
  config,
  lib,
  mainUser,
  nixpkgs-firefox-darwin,
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

    ./modules
  ];

  nixpkgs.overlays = [nixpkgs-firefox-darwin.overlay];

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

  environment.shells = [bashPkg];
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

      ./home
    ];

    # State Version: DO NOT CHANGE
    home.stateVersion = "25.11";

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
    };
  };
}
