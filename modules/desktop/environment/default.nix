self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkBind mkEnvs;

  inherit (lib) attrValues mkIf mkLuaInline optionalAttrs replaceStrings;

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

        configType = "lua";

        systemd.variables = ["-all"];

        settings = {
          env = let
            mkGSchemas = pkg: "${pkg}/share/gsettings-schemas/${pkg.name}";
          in
            mkEnvs ({
                GTK_USE_PORTAL = "1";
                NIXOS_OZONE_WL = "1";
                ELECTRON_OZONE_PLATFORM_HINT = "auto";

                XDG_DATA_DIRS = mkLuaInline ''"${mkGSchemas pkgs.gsettings-desktop-schemas}:${mkGSchemas pkgs.gtk3}:" .. os.getenv("XDG_DATA_DIRS")'';
              }
              // (optionalAttrs config.nvidia.enable {
                LIBVA_DRIVER_NAME = "nvidia";
                XDG_SESSION_TYPE = "wayland";
                GBM_BACKEND = "nvidia-drm";
                __GLX_VENDOR_LIBRARY_NAME = "nvidia";
              }));

          config = {
            xwayland.force_zero_scaling = true;

            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
              disable_watchdog_warning = true;
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

          monitor = [
            # Plug N' Play for unknown monitors
            {
              output = "";
              mode = "preferred";
              position = "auto";
              scale = "1";
            }
            {
              output = "desc:Lenovo Group Limited 0x41A0";
              mode = "1920x1200@60";
              position = "0x2920";
              scale = "1";
            }
            {
              output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D";
              mode = "2560x1440@120";
              position = "0x100";
              scale = "1";
              transform = 3;
            }

            # Same Model so we use the adapter name unfortunately
            {
              output = "DP-1";
              mode = "2560x1440@179.880000";
              position = "1440x0";
              scale = "1";
            }
            {
              output = "DP-2";
              mode = "2560x1440@179.880000";
              position = "1440x1440";
              scale = "1";
            }

            {
              output = "desc:Sharp Corporation LC-40LB480U 0x00000001";
              mode = "1680x1050";
              position = "auto";
              scale = "1";
              mirror = cfg.mainMonitor;
            }
          ];

          bind = map mkBind [
            # Defaults
            {
              keys = "SUPER + F";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.fullscreen({
                      mode = "fullscreen",
                      action = "toggle"
                  })
                '';
            }
            {
              keys = "SUPER + C";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.close()
                '';
            }
            {
              keys = "SUPER + SHIFT + SPACE";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.float({ action = "toggle" })
                '';
            }
            {
              keys = "SUPER + J";
              dispatcher =
                # lua
                ''
                  hl.dsp.layout("togglesplit")
                '';
            }

            ## Move focus with arrow keys
            {
              keys = "SUPER + left";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ direction = "left" })
                '';
            }
            {
              keys = "SUPER + right";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ direction = "right" })
                '';
            }
            {
              keys = "SUPER + up";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ direction = "up" })
                '';
            }
            {
              keys = "SUPER + down";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ direction = "down" })
                '';
            }

            ## Move to specific workspaces
            {
              keys = "SUPER + 1";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ workspace = 1 })
                '';
            }
            {
              keys = "SUPER + 2";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ workspace = 2 })
                '';
            }
            {
              keys = "SUPER + 3";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ workspace = 3 })
                '';
            }
            {
              keys = "SUPER + 4";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ workspace = 4 })
                '';
            }
            {
              keys = "SUPER + 5";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ workspace = 5 })
                '';
            }
            {
              keys = "SUPER + 6";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ workspace = 6 })
                '';
            }
            {
              keys = "SUPER + 7";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ workspace = 7 })
                '';
            }
            {
              keys = "SUPER + 8";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ workspace = 8 })
                '';
            }
            {
              keys = "SUPER + 9";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ workspace = 9 })
                '';
            }
            {
              keys = "SUPER + 0";
              dispatcher =
                # lua
                ''
                  hl.dsp.focus({ workspace = 10 })
                '';
            }

            # Move active window to a workspace
            {
              keys = "SUPER + SHIFT + 1";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.move({ workspace = 1 })
                '';
            }
            {
              keys = "SUPER + SHIFT + 2";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.move({ workspace = 2 })
                '';
            }
            {
              keys = "SUPER + SHIFT + 3";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.move({ workspace = 3 })
                '';
            }
            {
              keys = "SUPER + SHIFT + 4";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.move({ workspace = 4 })
                '';
            }
            {
              keys = "SUPER + SHIFT + 5";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.move({ workspace = 5 })
                '';
            }
            {
              keys = "SUPER + SHIFT + 6";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.move({ workspace = 6 })
                '';
            }
            {
              keys = "SUPER + SHIFT + 7";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.move({ workspace = 7 })
                '';
            }
            {
              keys = "SUPER + SHIFT + 8";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.move({ workspace = 8 })
                '';
            }
            {
              keys = "SUPER + SHIFT + 9";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.move({ workspace = 9 })
                '';
            }
            {
              keys = "SUPER + SHIFT + 0";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.move({ workspace = 10 })
                '';
            }

            # Mouse Binds
            {
              keys = "SUPER + mouse:272";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.drag()
                '';
              flags.mouse = true;
            }
            {
              keys = "SUPER + mouse:273";
              dispatcher =
                # lua
                ''
                  hl.dsp.window.resize()
                '';
              flags.mouse = true;
            }
          ];
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
