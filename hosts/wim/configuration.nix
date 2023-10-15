{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/audio.nix
    ../../modules/kmscon.nix
    ../../modules/plymouth.nix
    ../../modules/printer.nix
    ../../modules/proton-bridge.nix

    ./cfg/main.nix
    ./home/main.nix
  ];

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "wim";
    networkmanager = {
      enable = true;
      wifi.backend = "wpa_supplicant";
    };
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
