# Not currently operational
{config, ...}: let
  inherit (config.vars) mainUser hostName;
in {
  imports = [
    ./hardware-configuration.nix

    ../../modules/sshd.nix
    ../../modules/tailscale.nix

    ./modules/remote-builder.nix
  ];

  vars = {
    mainUser = "matt";
    hostName = "oksys";
    neovimIde = false;
  };

  users.users.${mainUser} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "adm"
    ];
  };
  home-manager.users.${mainUser} = {
    imports = [];

    # No touchy
    home.stateVersion = "24.05";
  };

  networking = {
    inherit hostName;
    resolvconf.enable = true;
    firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "24.05";
}
