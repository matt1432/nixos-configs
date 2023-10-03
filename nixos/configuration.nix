{ ... }:

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
    #font = "Lat2-Terminus16";
    keyMap = "ca";
    #useXkbConfig = true; # use xkbOptions in tty.
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_FONT_DPI		 = "125";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
