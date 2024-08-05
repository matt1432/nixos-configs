{pkgs, ...}: let
  defaultSession = "plasma";
in {
  imports = [
    (import ./session-switching.nix defaultSession)
    (import ./steam.nix defaultSession)
  ];

  services.desktopManager.plasma6.enable = true;

  programs = {
    kdeconnect.enable = true;
    xwayland.enable = true;
  };

  # Flatpak support for Discover
  services.flatpak.enable = true;
  services.packagekit.enable = true;

  environment.systemPackages = with pkgs; [
    # Misc Apps
    firefox
    kdePackages.discover
    kdePackages.krfb

    # Libs
    wl-clipboard
    xclip
  ];
}
