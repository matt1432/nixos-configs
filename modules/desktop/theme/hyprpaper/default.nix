{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;
  wallpaper = toString pkgs.scopedPackages.dracula.wallpaper;
in {
  config = mkIf cfg.enable {
    home.packages = [pkgs.hyprpaper];

    xdg.configFile."hypr/hyprpaper.conf" = {
      text = lib.hm.generators.toHyprconf {
        attrs = {
          ipc = "on";
          splash = false;

          preload = [wallpaper];

          wallpaper = [
            ",${wallpaper}"
          ];
        };
      };
    };
  };
}
