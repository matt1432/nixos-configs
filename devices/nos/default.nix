{
  config,
  self,
  ...
}: let
  inherit (config.vars) mainUser;
in {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    ./hardware-configuration.nix

    ./modules

    self.nixosModules.docker
    self.nixosModules.kmscon
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "24.05";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  vars = {
    mainUser = "matt";
    promptMainColor = "orange";
  };

  users.users.${mainUser} = {
    isNormalUser = true;
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
  roles.server = {
    user = mainUser;
    tailscale.enable = true;
    sshd.enable = true;
  };

  services.kmscon.enable = true;

  home-manager.users.${mainUser} = {
    imports = [];

    programs.neovim = {
      enable = true;
      enableIde = true;
      user = mainUser;
    };
  };
}
