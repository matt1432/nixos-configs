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
    ../../modules/tailscale.nix

    ./modules/security.nix

    self.nixosModules.desktop
    self.nixosModules.plymouth
  ];

  vars = {
    mainUser = "matt";
    hostName = "wim";
    promptMainColor = "purple";
  };

  roles.desktop = {
    user = config.vars.mainUser;

    mainMonitor = "eDP-1";
    isLaptop = true;
    isTouchscreen = true;

    fontSize = 12.5;
  };

  boot.plymouth = {
    enable = true;
    theme = "dracula";
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
    home.stateVersion = "23.05";
  };

  networking = {
    inherit hostName;
    networkmanager = {
      enable = true;
      wifi.backend = "wpa_supplicant";
    };
    firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "23.05";
}
