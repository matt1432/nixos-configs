{
  config,
  self,
  ...
}: let
  inherit (config.vars) mainUser hostName;
in {
  imports = [
    ./hardware-configuration.nix

    ../../modules/android.nix
    ../../modules/ags
    ../../modules/audio.nix
    ../../modules/kmscon.nix
    ../../modules/printer.nix
    ../../modules/ratbag-mice.nix
    ../../modules/sshd.nix
    ../../modules/tailscale.nix

    ./modules/gpu-replay.nix
    ./modules/nix-gaming.nix

    self.nixosModules.desktop
  ];

  vars = {
    mainUser = "matt";
    hostName = "binto";
    promptMainColor = "purple";
  };

  roles.desktop = {
    user = config.vars.mainUser;

    mainMonitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D";
    displayManager.duplicateScreen = false;

    fontSize = 12.5;
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
  home-manager.users.${mainUser} = {
    imports = [
      ../../home/firefox
    ];

    # No touchy
    home.stateVersion = "23.11";
  };

  networking = {
    inherit hostName;
    networkmanager.enable = true;
    firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "23.11";
}
