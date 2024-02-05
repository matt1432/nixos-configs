{
  ags,
  config,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser hostName;

  isTouchscreen = config.hardware.sensor.iio.enable;
in {
  services.upower.enable = true;

  home-manager.users.${mainUser}.imports = [
    ags.homeManagerModules.default

    ({
      config,
      lib,
      ...
    }: let
      symlink = config.lib.file.mkOutOfStoreSymlink;
      inherit (lib) optionalAttrs optionals;

      cfgHypr = config.wayland.windowManager.hyprland;
    in {
      programs.ags.enable = true;

      home = {
        file = {
          ".config/ags".source = symlink /home/${mainUser}/.nix/modules/ags/config;
          ".nix/modules/ags/config/config.js".text =
            /*
            javascript
            */
            ''
              import { transpileTypeScript } from './js/utils.js';

              export default (await transpileTypeScript('${hostName}')).default;
            '';
        };

        packages =
          [config.customPkgs.coloryou]
          ++ (with pkgs; [
            # ags
            sassc
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
          exec-once = [
            "ags"
            "sleep 3; ags -r 'App.openWindow(\"applauncher\")'"
          ];

          bindn = [",Escape, exec, ags run-js 'closeAll()'"];
          bind = [
            "$mainMod SHIFT, E     , exec, ags -t powermenu"
            "$mainMod      , D     , exec, ags -t applauncher"
          ];
          binde = [
            ## Brightness control
            ", XF86MonBrightnessUp, exec, ags -r 'Brightness.screen += 0.05'"
            ", XF86MonBrightnessDown, exec, ags -r 'Brightness.screen -= 0.05'"
          ];
          bindr = ["CAPS, Caps_Lock, exec, ags -r 'Brightness.fetchCapsState()'"];
        };
      };
    })
  ];
}
