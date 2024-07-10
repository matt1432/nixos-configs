{
  ags,
  astal-tray,
  config,
  gtk-session-lock,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) boolToString;

  # Configs
  inherit (config.vars) mainUser hostName;
  cfgDesktop = config.roles.desktop;
  flakeDir = config.environment.variables.FLAKE;
  isTouchscreen = config.hardware.sensor.iio.enable;

  # Packages
  astalTray = astal-tray.packages.${pkgs.system}.tray;
  gtkSessionLock = gtk-session-lock.packages.${pkgs.system}.default;
in {
  # Enable pam for ags and astal
  security.pam.services.ags = {};

  services.upower.enable = true;

  home-manager.users.${mainUser}.imports = [
    ags.homeManagerModules.default

    ({
      config,
      lib,
      ...
    }: let
      inherit (config.lib.file) mkOutOfStoreSymlink;
      inherit (lib) hasPrefix optionals removePrefix;

      configJs =
        # javascript
        ''
          import { transpileTypeScript } from './js/utils.js';

          export default (await transpileTypeScript('${hostName}')).default;
        '';

      agsConfigDir = "${removePrefix "/home/${mainUser}/" flakeDir}/modules/ags";
    in {
      assertions = [
        {
          assertion = hasPrefix "/home/${mainUser}/" flakeDir;
          message = ''
            Your $FLAKE environment variable needs to point to a directory in
            the main users' home to use the AGS module.
          '';
        }
      ];

      programs.ags = {
        enable = true;
        extraPackages = [
          astalTray
          gtkSessionLock
        ];
      };

      home = {
        file =
          {
            # Out of store symlinks
            ".config/ags".source = mkOutOfStoreSymlink "${flakeDir}/modules/ags/config";

            # Generated types
            "${agsConfigDir}/config/types" = {
              source = "${config.programs.ags.finalPackage}/share/com.github.Aylur.ags/types";
              recursive = true; # To add other types inside the folder
            };
            "${agsConfigDir}/config/types/gtk-session-lock".source =
              pkgs.callPackage ./third-party-types/lock.nix {inherit gtkSessionLock;};
            "${agsConfigDir}/config/types/astal-tray".source =
              pkgs.callPackage ./third-party-types/tray.nix {inherit astalTray;};

            # Generated JavaScript files
            "${agsConfigDir}/config/config.js".text = configJs;
            "${agsConfigDir}/config/ts/lockscreen/vars.ts".text =
              # javascript
              ''
                export default {
                    mainMonitor: '${cfgDesktop.mainMonitor}',
                    dupeLockscreen: ${boolToString cfgDesktop.displayManager.duplicateScreen},
                    hasFprintd: ${boolToString (hostName == "wim")},
                };
              '';
          }
          // (import ./icons.nix {inherit pkgs agsConfigDir;});

        packages =
          [
            # TODO: replace with matugen
            self.packages.${pkgs.system}.coloryou
          ]
          ++ (with pkgs; [
            # ags
            dart-sass
            bun
            playerctl
            (callPackage ./clipboard {})

            ## gui
            pavucontrol # TODO: replace with ags widget
          ])
          ++ (optionals isTouchscreen (with pkgs; [
            lisgd
            ydotool
          ]));
      };

      wayland.windowManager.hyprland = {
        settings = {
          animations = {
            bezier = [
              "easeInOutBack,   0.68, -0.6, 0.32, 1.6"
            ];

            animation = [
              "fadeLayersIn, 0"
              "fadeLayersOut, 1, 3000, default"
              "layers, 1, 8, easeInOutBack, slide left"
            ];
          };

          layerrule = [
            "noanim, ^(?!win-).*"

            # Lockscreen blur
            "blur, ^(blur-bg.*)"
            "ignorealpha 0.19, ^(blur-bg.*)"
          ];

          exec-once = [
            "ags"
            "sleep 3; ags -r 'App.openWindow(\"win-applauncher\")'"
          ];

          bind = [
            "$mainMod SHIFT, E    , exec, ags -t win-powermenu"
            "$mainMod      , D    , exec, ags -t win-applauncher"
            "$mainMod      , V    , exec, ags -t win-clipboard"
            "              , Print, exec, ags -t win-screenshot"
          ];
          binde = [
            ## Brightness control
            ", XF86MonBrightnessUp  , exec, ags -r 'Brightness.screen += 0.05'"
            ", XF86MonBrightnessDown, exec, ags -r 'Brightness.screen -= 0.05'"
          ];
          bindn = ["    , Escape   , exec, ags -r 'closeAll()'"];
          bindr = ["CAPS, Caps_Lock, exec, ags -r 'Brightness.fetchCapsState()'"];
        };
      };
    })
  ];
}
