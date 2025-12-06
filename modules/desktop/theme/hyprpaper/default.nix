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

    # NB: order of props in wallpaper matters
    xdg.configFile."hypr/hyprpaper.conf".text =
      # hyprlang
      ''
        ipc    = true
        splash = false

        wallpaper {
            monitor  =
            path     = ${wallpaper}
            fit_mode = cover
        }
      '';
  };
}
