{config, ...}: let
  inherit (config.vars) mainUser hostName;
  tailscaleNameservers =
    config
    .services
    .headscale
    .settings
    .dns_config
    .nameservers;
in {
  imports = [
    ./hardware-configuration.nix

    ../../modules/sshd.nix
    ../../modules/tailscale.nix

    ./modules/blocky.nix
    ./modules/headscale
    ./modules/remote-builder.nix
    ./modules/unbound.nix
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
    nameservers = tailscaleNameservers ++ ["1.0.0.1"];
    firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "24.05";
}
