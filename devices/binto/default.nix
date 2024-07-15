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

    ../../modules/ags
    ../../modules/audio.nix
    ../../modules/kmscon.nix
    ../../modules/printer.nix
    ../../modules/ratbag-mice.nix
    ../../modules/sshd.nix
    ../../modules/tailscale.nix

    ./modules/gpu-replay.nix
    ./modules/nix-gaming.nix

    self.nixosModules.adb
    self.nixosModules.desktop
  ];

  home-manager.users.${mainUser} = {
    imports = [
      ../../home/firefox
    ];

    # State Version: DO NOT CHANGE
    home.stateVersion = "23.11";
  };
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

    mainMonitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D";
    displayManager.duplicateScreen = false;

    fontSize = 12.5;
  };

  programs.adb = {
    enable = true;
    user = mainUser;
  };
}
