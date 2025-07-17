{pkgs, ...}: let
  defaultSession = "plasma";
in {
  imports = [
    (import ./session-switching.nix defaultSession)
    (import ./steam.nix defaultSession)
  ];

  services = {
    desktopManager.plasma6.enable = true;

    power-profiles-daemon.enable = false;
    tlp.enable = true;
  };

  programs = {
    kdeconnect.enable = true;
    xwayland.enable = true;
  };

  # Flatpak support for Discover
  services.flatpak.enable = true;
  services.packagekit.enable = true;

  # Wayland env vars
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

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
