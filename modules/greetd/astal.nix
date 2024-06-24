{
  astal,
  config,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;

  hyprland =
    config
    .home-manager
    .users
    .${mainUser}
    .wayland
    .windowManager
    .hyprland
    .finalPackage;
in {
  # Add home folder for home-manager to work
  users.users.greeter = {
    home = "/var/lib/greeter";
    createHome = true;
  };

  home-manager.users.greeter = {
    imports = [
      astal.homeManagerModules.default
      ../../home/theme
      ../../home/wpaperd.nix
    ];

    programs.astal.enable = true;

    home.packages = [
      hyprland
      pkgs.bun
      pkgs.dart-sass
      pkgs.gtk3
      pkgs.glib
    ];

    xdg.configFile = {
      "astal" = {
        source = ../ags/astal;
        recursive = true;
      };

      "astal/config.js".text =
        # javascript
        ''
          import { transpileTypeScript } from './js/utils.js';

          Utils.execAsync('wpaperd -d');

          export default (await transpileTypeScript('greeter')).default;
        '';
    };
  };
}
