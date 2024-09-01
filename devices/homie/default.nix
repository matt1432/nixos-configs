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

    ./modules/home-assistant.nix

    self.nixosModules.kmscon
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "24.11";
  home-manager.users.${mainUser}.home.stateVersion = "24.11";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  vars = {
    mainUser = "matt";
    hostName = "homie";
    promptMainColor = "yellow";
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
}
