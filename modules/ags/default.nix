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
    })
  ];
}
