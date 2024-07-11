{
  config,
  jovian,
  self,
  ...
}: let
  inherit (config.vars) mainUser hostName;
in {
  imports = [
    jovian.nixosModules.default
    ../../modules/kmscon.nix
    ../../modules/sshd.nix

    ./hardware-configuration.nix

    ./modules/desktop.nix

    self.nixosModules.plymouth
  ];

  vars = {
    mainUser = "mariah";
    hostName = "bbsteamie";
    promptMainColor = "pink";
  };

  boot.plymouth = {
    enable = true;
    theme = "steamos";
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
    networkmanager.enable = true;
  };

  home-manager.users.${mainUser} = {
    imports = [];

    # No touchy
    home.stateVersion = "24.11";
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "24.11";
}
