self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkBind mkMonitor;

  inherit (lib) attrValues concatStringsSep mkIf optionals replaceStrings;

  cfg = config.roles.desktop;

  hyprCfg =
    config
    .home-manager
    .users
    .${cfg.user}
    .wayland
    .windowManager
    .hyprland;
in {
  imports = [
    (import ../../ags self)

    ./modules/dconf.nix
    ./modules/printer.nix
    ./modules/ratbag-mice.nix
    (import ./modules/audio.nix self)
    (import ./modules/packages.nix self)
    (import ./modules/security.nix self)
  ];

  config = mkIf cfg.enable {
    services = {
      dbus.enable = true;
      gvfs.enable = true;
      libinput.enable = true;
      xserver.wacom.enable = cfg.isTouchscreen;
    };

    programs.hyprland = {
      enable = true;
      package = hyprCfg.finalPackage;
      portalPackage = hyprCfg.finalPortalPackage;
    };

    xdg.portal = {
      enable = true;

      extraPortals = [
        pkgs.kdePackages.xdg-desktop-portal-kde
        pkgs.xdg-desktop-portal-gtk
      ];

      config.hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];

        "org.freedesktop.impl.portal.FileChooser" = [
          "kde"
        ];
      };
    };

    home-manager.users.${cfg.user} = {
      imports = [
        ./home/dev.nix

        # Plugins
        (import ./home/hyprexpo.nix self)
        (import ./home/hyprgrass.nix self)

        (import ./home/inputs.nix self)
        (import ../theme self)
      ];

      wayland.windowManager.hyprland = {
        enable = true;

        # Get rid of logs shown on the TTY right before Hyprland launches
        package = pkgs.hyprland.overrideAttrs (o: {
          postInstall = replaceStrings ["--suffix"] ["--append-flags '&>/dev/null' --suffix"] o.postInstall;
        });

        systemd.variables = ["-all"];

        settings = {
          envd = let
            mkGSchemas = pkg: "${pkg}/share/gsettings-schemas/${pkg.name}";
          in
            [
              "GTK_USE_PORTAL, 1"
              "NIXOS_OZONE_WL, 1"
              "ELECTRON_OZONE_PLATFORM_HINT, auto"

              "XDG_DATA_DIRS, ${concatStringsSep ":" [
                (mkGSchemas pkgs.gsettings-desktop-schemas)
                (mkGSchemas pkgs.gtk3)
                "$XDG_DATA_DIRS"
              ]}"
            ]
            ++ (optionals config.nvidia.enable [
              "LIBVA_DRIVER_NAME, nvidia"
              "XDG_SESSION_TYPE, wayland"
              "GBM_BACKEND, nvidia-drm"
              "__GLX_VENDOR_LIBRARY_NAME, nvidia"
            ]);

          xwayland.force_zero_scaling = true;
          monitor =
            # Plug N' Play for unknown monitors
            [",preferred,auto,1"]
            ++ map mkMonitor [
              {
                description = "Lenovo Group Limited 0x41A0";
                resolution = "1920x1200";
                refreshRate = 60;
                position = "0x2920";
              }
              {
                description = "GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D";
                resolution = "2560x1440";
                refreshRate = 120;
                position = "0x100";
                transform = "270";
              }

              # Same Model so we use the adapter name unfortunately
              {
                name = "DP-1";
                resolution = "2560x1440";
                refreshRate = 179.88;
                position = "1440x0";
              }
              {
                name = "DP-2";
                resolution = "2560x1440";
                refreshRate = 179.88;
                position = "1440x1440";
              }

              {
                description = "Sharp Corporation LC-40LB480U 0x00000001";
                resolution = "1680x1050";
                mirror = cfg.mainMonitor;
              }
            ];

          "$mainMod" = "SUPER";

          bind = [
            # Defaults
            "$mainMod, F,    fullscreen"
            "$mainMod, C,    killactive"
            "$mainMod SHIFT, SPACE,     togglefloating"
            "$mainMod, J,    layoutmsg, togglesplit"

            ## Move focus with arrow keys
            "$mainMod, left,  movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up,    movefocus, u"
            "$mainMod, down,  movefocus, d"

            ## Move to specific workspaces
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            # Move active window to a workspace
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"
          ];

          # Mouse Binds
          bindm = map mkBind [
            {
              modifier = "$mainMod";
              key = "mouse:272";
              dispatcher = "movewindow";
            }
            {
              modifier = "$mainMod";
              key = "mouse:273";
              dispatcher = "resizewindow";
            }
          ];

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            disable_watchdog_warning = true;
            vfr = true;
          };

          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };

          dwindle = {
            smart_split = true;
            special_scale_factor = 0.8;
          };
        };
      };

      # libs
      home.packages = attrValues {
        inherit
          (pkgs)
          bluez-tools
          brightnessctl
          pulseaudio
          alsa-utils
          libayatana-appindicator
          xdg-utils
          evtest
          glib
          libinput
          xclip
          libnotify
          xrandr
          ;

        qt5Wayland = pkgs.qt5.qtwayland;
        qt6Wayland = pkgs.qt6.qtwayland;
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
