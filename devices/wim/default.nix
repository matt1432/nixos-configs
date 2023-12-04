{config, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/ags
    ../../modules/audio.nix
    ../../modules/hyprland
    ../../modules/kmscon.nix
    ../../modules/plymouth.nix
    ../../modules/printer.nix
    ../../modules/proton-bridge.nix
    ../../modules/tailscale.nix

    ./modules/security.nix
  ];

  vars = {
    user = "matt";
    hostName = "wim";
    fontSize = 12.5;
  };

  users.users.${config.vars.user} = {
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
  home-manager.users .${config.vars.user} = {
    imports = [
      ../../home/dconf.nix
      ../../home/firefox

      ./home/dotfiles.nix
      ./home/packages.nix
    ];

    # No touchy
    home.stateVersion = "23.05";
  };

  networking = {
    inherit (config.vars) hostName;
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
