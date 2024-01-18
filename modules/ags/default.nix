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
      optionals = lib.lists.optionals;
    in {
      programs.ags = {
        enable = true;
        configDir = symlink /home/${mainUser}/.nix/modules/ags/config;
        package = ags.packages.${pkgs.system}.default;
      };

      home = {
        file = {
          ".config/ags/config.js".text =
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

            (writeShellApplication {
              name = "updateTypes";
              runtimeInputs = [nodejs_18 typescript git];
              text = ''
                if [[ -d /tmp/ags-types ]]; then
                  rm -r /tmp/ags-types
                fi
                rm -r ~/.config/ags/types

                git clone https://github.com/Aylur/ags.git /tmp/ags-types
                /tmp/ags-types/example/starter-config/setup.sh

                rm -r /tmp/ags-types
              '';
            })
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
