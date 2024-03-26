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
      inherit (lib) optionals;

      astalTypes = config.home.file.".local/share/io.Aylur.Astal/types";
      astalConfigDir = ".nix/modules/ags/astal"; # FIXME: figure out way to use $FLAKE

      # https://github.com/Aylur/ags/blob/e1f2d311ceb496a69ef6daa6aebb46ce511b2f22/nix/hm-module.nix#L69
      agsTypes = config.home.file.".local//share/com.github.Aylur.ags/types";
      agsConfigDir = ".nix/modules/ags/config"; # FIXME: figure out way to use $FLAKE

      configJs =
        /*
        javascript
        */
        ''
          import { transpileTypeScript } from './js/utils.js';

          export default (await transpileTypeScript('${hostName}')).default;
        '';
    in {
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
            ".config/astal".source = symlink "${flakeDir}/modules/ags/astal";
            "${astalConfigDir}/types".source = astalTypes.source;
            "${astalConfigDir}/config.js".text = configJs;

            ".config/ags".source = symlink "${flakeDir}/modules/ags/config";
            "${agsConfigDir}/types".source = agsTypes.source;
            "${agsConfigDir}/config.js".text = configJs;
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
