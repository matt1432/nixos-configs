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
      inherit (lib) optionals;

      # https://github.com/Aylur/ags/blob/e1f2d311ceb496a69ef6daa6aebb46ce511b2f22/nix/hm-module.nix#L69
      agsTypes = config.home.file.".local//share/com.github.Aylur.ags/types";
      agsConfigDir = ".nix/modules/ags/config";
    in {
      programs.ags.enable = true;

      home = {
        file = {
          ".config/ags".source = symlink /home/${mainUser}/.nix/modules/ags/config;

          # Icons
          "${agsConfigDir}/icons/mouse-razer-symbolic.svg".source = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/bithatch/razer-icon-font/main/src/devices/mouse.svg";
            hash = "sha256-A1+eIp2VEFDyY23GIHKhbnByHXrnVS3QgIJ9sjjtuZw=";
          };
          "${agsConfigDir}/icons/down-large-symbolic.svg".source = pkgs.fetchurl {
            url = "https://www.svgrepo.com/download/158537/down-chevron.svg";
            hash = "sha256-mOfNjgZh0rt6XosKA2kpLY22lJldSS1XCphgrnvZH1s=";
          };

          "${agsConfigDir}/types".source = agsTypes.source;
          "${agsConfigDir}/config.js".text =
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
          exec-once =
            [
              "ags"
              "sleep 3; ags -r 'App.openWindow(\"applauncher\")'"
            ]
            ++ optionals isTouchscreen ["squeekboard"];

          bind = [
            "$mainMod SHIFT, E     , exec, ags -t powermenu"
            "$mainMod      , D     , exec, ags -t applauncher"
          ];
          binde = [
            ## Brightness control
            ", XF86MonBrightnessUp,   exec, ags -r 'Brightness.screen += 0.05'"
            ", XF86MonBrightnessDown, exec, ags -r 'Brightness.screen -= 0.05'"
          ];
          bindn = [",Escape, exec, ags run-js 'closeAll()'"];
          bindr = ["CAPS, Caps_Lock, exec, ags -r 'Brightness.fetchCapsState()'"];
        };
      };
    })
  ];
}
