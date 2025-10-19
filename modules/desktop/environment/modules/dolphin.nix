{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.roles.desktop;
in {
  # https://github.com/NixOS/nixpkgs/blob/443424323ed4ff51b4f4314af39e0f57bb103586/nixos/modules/services/desktop-managers/plasma6.nix
  config = mkIf cfg.enable {
    # To make it work with firefox
    # https://www.reddit.com/r/NixOS/comments/xtoubc/comment/koxxr3e/?utm_source=share&utm_medium=web2x&context=3
    systemd.user.services.plasma-dolphin = {
      unitConfig = {
        Description = "Dolphin file manager";
        PartOf = ["graphical-session.target"];
      };
      path = ["/run/current-system/sw"];
      environment.QT_QPA_PLATFORM = "wayland";
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.FileManager1";
        ExecStart = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      };
      wantedBy = ["graphical-session.target"];
    };

    services.udisks2.enable = true;

    # Enable GTK applications to load SVG icons
    programs.gdk-pixbuf.modulePackages = [pkgs.librsvg];

    # Fix application associations
    home-manager.users.${cfg.user}.xdg.configFile."menus/applications.menu"
      .source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

    environment.systemPackages = attrValues {
      # Complete apps
      inherit
        (pkgs.kdePackages)
        ark
        dolphin
        kcharselect
        kmenuedit
        kinfocenter
        plasma-systemmonitor
        ksystemstats
        libksysguard
        systemsettings
        kcmutils
        ;

      # globally loadable bits
      inherit
        (pkgs.kdePackages)
        frameworkintegration # provides Qt plugin
        kauth # provides helper service
        kcoreaddons # provides extra mime type info
        kded # provides helper service
        kfilemetadata # provides Qt plugins
        kguiaddons # provides geo URL handlers
        kiconthemes # provides Qt plugins
        kimageformats # provides Qt plugins
        qtimageformats # provides optional image formats such as .webp and .avif
        kio # provides helper service + a bunch of other stuff
        kio-admin # managing files as admin
        kio-extras # stuff for MTP, AFC, etc
        kio-fuse # fuse interface for KIO
        kpackage # provides kpackagetool tool
        kservice # provides kbuildsycoca6 tool
        kunifiedpush # provides a background service and a KCM
        plasma-activities # provides plasma-activities-cli tool
        solid # provides solid-hardware6 tool
        phonon-vlc # provides Phonon plugin
        ;

      inherit
        (pkgs)
        xdg-user-dirs
        ;

      inherit
        (pkgs.kdePackages)
        baloo-widgets
        dolphin-plugins
        ffmpegthumbs
        kde-cli-tools
        kdegraphics-thumbnailers
        kmime
        qtsvg
        ;
    };
  };

  # For accurate stack trace
  _file = ./dolphin.nix;
}
