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

    ./modules

    self.nixosModules.adb
    self.nixosModules.desktop
    self.nixosModules.kmscon
    self.nixosModules.server
  ];

  home-manager.users.${mainUser}.imports = [
    self.homeManagerModules.firefox
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "23.11";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  vars = {
    mainUser = "matt";
    hostName = "binto";
    promptMainColor = "purple";
  };

  users.users.${mainUser} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "uinput"
      "adm"
      "video"
      "libvirtd"
    ];
  };

  networking = {
    inherit hostName;
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  roles.desktop = {
    user = mainUser;

    ags.enable = true;
    mainMonitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D";
    displayManager.duplicateScreen = false;

    fontSize = 12.5;
  };

  roles.server = {
    user = mainUser;
    tailscale.enable = true;
    sshd.enable = true;
  };

  programs.adb = {
    enable = true;
    user = mainUser;
  };

  services.kmscon.enable = true;
}
