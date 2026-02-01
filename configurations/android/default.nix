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
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "26.05";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  users.users.${mainUser}.uid = 1000;

  avf.defaultUser = mainUser;

  networking = {
    hostName = "avf";
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

  home-manager.sharedModules = [
    self.homeManagerModules.neovim
    self.homeManagerModules.shell

    {
      programs = {
        bash = {
          enable = true;
          promptMainColor = "purple";
          shellAliases = {
            # SSH
            # Desktop
            pc = "ssh -t matt@100.64.0.6 'tmux -2u new -At phone'";

            # NAS
            nos = "ssh -t matt@100.64.0.4 'tmux -2u new -At phone'";

            # Build server
            servivi = "ssh -t matt@100.64.0.7 'tmux -2u new -At phone'";

            # Home-assistant
            homie = "ssh -t matt@100.64.0.10 'tmux -2u new -At phone'";

            # Cluster nodes
            thingone = "ssh -t matt@100.64.0.8 'tmux -2u new -At phone'";
            thingtwo = "ssh -t matt@100.64.0.9 'tmux -2u new -At phone'";
          };
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
