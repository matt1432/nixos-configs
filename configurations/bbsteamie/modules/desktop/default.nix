{
  nixpkgs,
  nixpkgs-kde63,
  pkgs,
  ...
}: let
  defaultSession = "plasma";
in {
  # -= KDE 6.3.5
  disabledModules = ["${nixpkgs}/nixos/modules/services/desktop-managers/plasma6.nix"];
  nixpkgs.overlays = [
    (final: prev: {
      qt6Packages = final.callPackage "${nixpkgs-kde63}/pkgs/top-level/qt6-packages.nix" {};
      qt6 = final.callPackage "${nixpkgs-kde63}/pkgs/development/libraries/qt-6" {};
      kdePackages = final.callPackage "${nixpkgs-kde63}/pkgs/kde" {};
    })
  ];
  imports = [
    "${nixpkgs-kde63}/nixos/modules/services/desktop-managers/plasma6.nix"
    # KDE 6.3.5 =-

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
