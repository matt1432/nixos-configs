{
  mainUser,
  nixos-avf,
  self,
  ...
}: {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    nixos-avf.nixosModules.avf
    self.nixosModules.base
    self.nixosModules.meta
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "26.05";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  users.users.${mainUser}.uid = 1000;

  avf.defaultUser = mainUser;

  networking = {
    hostName = "android";
  };

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  meta = {
    roleDescription = "NixOS running on AVF on my phone";
    hardwareDescription = "Google Pixel 8";
  };

  roles.base = {
    enable = true;
    user = mainUser;
  };

  roles.server = {
    enable = true;
    user = mainUser;
    tailscale.enable = true;
  };

  home-manager.sharedModules = [
    self.homeManagerModules.neovim
    self.homeManagerModules.shell

    {
      programs = {
        bash = {
          enable = true;
          promptMainColor = "purple";
        };
        neovim = {
          enable = true;
          user = mainUser;

          ideConfig = {
            enableJava = false;
            enableNix = false;
            enableWeb = false;
          };
        };
      };
    }
  ];
}
