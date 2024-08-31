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

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      firefox
      wl-clipboard
      xclip
      ;

    inherit
      (pkgs.kdePackages)
      discover
      krfb
      ;
  };
}
