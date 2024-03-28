{
  ags,
  astal,
  config,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser hostName;

  flakeDir = config.environment.variables.FLAKE;
  isTouchscreen = config.hardware.sensor.iio.enable;
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

      programs.ags.enable = true;

      home = {
        file =
          {
            # Astal symlinks. ${./astal}, types and config.js
            ".config/astal".source = symlink "${flakeDir}/modules/ags/astal";
            "${agsConfigDir}/astal/types".source = "${config.programs.astal.finalPackage}/share/io.Aylur.Astal/types";
            "${agsConfigDir}/astal/config.js".text = configJs;

            # AGS symlinks. ${./config}, types and config.js
            ".config/ags".source = symlink "${flakeDir}/modules/ags/config";
            "${agsConfigDir}/config/types".source = "${config.programs.ags.finalPackage}/share/com.github.Aylur.ags/types";
            "${agsConfigDir}/config/config.js".text = configJs;
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
            squeekboard
            ydotool
          ]));
      };

      wayland.windowManager.hyprland = {
        settings = {
          animations.animation = [
            # Ags takes care of doing the animations
            "layers, 0"
          ];

          exec-once =
            [
              "ags"
              "sleep 3; ags -r 'App.openWindow(\"applauncher\")'"
            ]
            ++ optionals isTouchscreen ["squeekboard"];

          bind = [
            "$mainMod SHIFT, E, exec, ags -t powermenu"
            "$mainMod      , D, exec, ags -t applauncher"
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
