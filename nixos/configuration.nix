{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./overlays/list.nix
    ./cfg/main.nix
    ./home/main.nix
  ];

  networking = {
    hostName = "wim";
    networkmanager.enable = true;
    networkmanager.wifi.backend = "wpa_supplicant";
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  console = {
    keyMap = "ca";
  };
  services.kmscon = {
    enable = true;
    hwRender = true;
    # FIXME: https://github.com/Aetf/kmscon/issues/18    // Icons not rendering properly
    # FIXME: https://github.com/Aetf/kmscon/issues/56    // Mouse cursor stays
    extraOptions = "--font-size 12.5 --font-dpi 170 --font-name 'JetBrainsMono Nerd Font'";
  };

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
