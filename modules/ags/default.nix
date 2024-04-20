{
  ags,
  astal,
  config,
  gtk-session-lock,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) boolToString;
  inherit (config.vars) mainUser hostName mainMonitor greetdDupe;

  flakeDir = config.environment.variables.FLAKE;
  isTouchscreen = config.hardware.sensor.iio.enable;
  gtkSessionLock = gtk-session-lock.packages.${pkgs.system}.default;
in {
  # Enable pam for ags and astal
  security.pam.services.ags = {};
  security.pam.services.astal = {};

  services.upower.enable = true;

  home-manager.users.${mainUser}.imports = [
    ags.homeManagerModules.default
    astal.homeManagerModules.default

    ({
      config,
      lib,
      ...
    }: let
      symlink = config.lib.file.mkOutOfStoreSymlink;
      inherit (lib) hasPrefix mdDoc optionals removePrefix;

      configJs =
        /*
        javascript
        */
        ''
          import { transpileTypeScript } from './js/utils.js';

          export default (await transpileTypeScript('${hostName}')).default;
        '';

      agsConfigDir = "${removePrefix "/home/${mainUser}/" flakeDir}/modules/ags";
    in {
      assertions = [
        {
          assertion = hasPrefix "/home/${mainUser}/" flakeDir;
          message = mdDoc ''
            Your $FLAKE environment variable needs to point to a directory in
            the main users' home to use the AGS module.
          '';
        }
      ];

      # Experimental Gtk4 ags
      programs.astal = {
        enable = true;
        extraPackages = with pkgs; [
          libadwaita
        ];
      };

      programs.ags = {
        enable = true;
        extraPackages = [
          gtkSessionLock
        ];
      };

      home = {
        file =
          {
            # Astal symlinks. ${./astal}, types and config.js
            ".config/astal".source = symlink "${flakeDir}/modules/ags/astal";
            "${agsConfigDir}/astal/types".source = "${config.programs.astal.finalPackage}/share/io.Aylur.Astal/types";
            "${agsConfigDir}/astal/config.js".text = configJs;

            # AGS symlinks. ${./config}, types and config.js
            ".config/ags".source = symlink "${flakeDir}/modules/ags/config";
            "${agsConfigDir}/config/types" = {
              source = "${config.programs.ags.finalPackage}/share/com.github.Aylur.ags/types";
              recursive = true;
            };
            "${agsConfigDir}/config/types/gtk-session-lock".source = pkgs.callPackage ./gtk-session-lock-types {inherit gtkSessionLock;};
            "${agsConfigDir}/config/config.js".text = configJs;

            "${agsConfigDir}/config/ts/lockscreen/vars.ts".text =
              /*
              javascript
              */
              ''
                export default {
                    mainMonitor: '${mainMonitor}',
                    dupeLockscreen: ${boolToString greetdDupe},
                };
              '';
          }
          // (import ./icons.nix {inherit pkgs agsConfigDir;});

        packages =
          [config.customPkgs.coloryou]
          ++ (with pkgs; [
            # ags
            dart-sass
            bun
            playerctl

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
            "$mainMod SHIFT, E, exec, ags -t win-powermenu"
            "$mainMod      , D, exec, ags -t win-applauncher"
          ];
          binde = [
            ## Brightness control
            ", XF86MonBrightnessUp,   exec, ags -r 'Brightness.screen += 0.05'"
            ", XF86MonBrightnessDown, exec, ags -r 'Brightness.screen -= 0.05'"
          ];
          bindn = ["    , Escape,    exec, ags -r 'closeAll()'"];
          bindr = ["CAPS, Caps_Lock, exec, ags -r 'Brightness.fetchCapsState()'"];
        };
      };
    })
  ];
}
