{
  ags,
  config,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;
  hyprland = config.home-manager.users.${mainUser}.wayland.windowManager.hyprland.finalPackage;
in {
  # Add home folder for home-manager to work
  users.users.greeter = {
    home = "/var/lib/greeter";
    createHome = true;
  };

  home-manager.users.greeter = {
    imports = [
      ags.homeManagerModules.default
      ../../common/vars
      ../../home/theme
    ];

    programs.ags.enable = true;

    home = {
      packages = [
        hyprland
        pkgs.bun
        pkgs.dart-sass
        pkgs.swww
        pkgs.gtk3
        pkgs.glib
      ];

      file = {
        ".config/ags/.wallpaper".source = "${pkgs.dracula-theme}/wallpapers/waves.png";

        ".config/ags" = {
          source = ../ags/config;
          recursive = true;
        };

        ".config/ags/config.js".text =
          /*
          javascript
          */
          ''
            import { transpileTypeScript } from './js/utils.js';

            export default (await transpileTypeScript('greeter')).default;
          '';
      };
    };

    vars = config.vars;
    home.stateVersion = "24.05";
  };
}
