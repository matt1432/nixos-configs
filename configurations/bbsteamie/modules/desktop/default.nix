{
  nixpkgs,
  nixpkgs-kde63,
  pkgs,
  ...
}: let
  defaultSession = "plasma";

  kde63Pkgs = import nixpkgs-kde63 {
    inherit (pkgs) system cudaSupport;
  };
in {
  # -= KDE 6.3.1
  disabledModules = ["${nixpkgs}/nixos/modules/services/desktop-managers/plasma6.nix"];
  nixpkgs.overlays = [
    (final: prev: {
      # KRDP requires specific FreeRDP version
      inherit (kde63Pkgs) freerdp;

      # Fixes plasma-workspace and other calls to substituteAll
      substituteAll = attrs:
        final.replaceVars attrs.src (
          (builtins.removeAttrs attrs ["src"]) // {QtBinariesDir = null;}
        );

      kdePackages = (final.callPackage "${nixpkgs-kde63}/pkgs/kde" {}).overrideScope (
        kdeFinal: kdePrev: {
          threadweaver = kdePrev.threadweaver.overrideAttrs (o: {
            postPatch = ''
              ${o.postPatch or ""}
              substituteInPlace ./CMakeLists.txt --replace-fail \
                  'add_subdirectory(examples)' ""
            '';
          });

          inherit
            (prev.kdePackages)
            breeze
            kdeconnect-kde
            ktextaddons
            kpimtextedit
            konsole
            ;
        }
      );
    })
  ];
  imports = [
    "${nixpkgs-kde63}/nixos/modules/services/desktop-managers/plasma6.nix"
    # KDE 6.3.1 =-

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
