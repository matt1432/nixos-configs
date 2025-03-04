self: {
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;

  hyprpaper = self.inputs.hyprpaper.packages.${pkgs.system}.default;
  wallpaper = toString pkgs.scopedPackages.dracula.wallpaper;
in {
  config = mkIf cfg.enable {
    home.packages = [hyprpaper];

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

  # For accurate stack trace
  _file = ./default.nix;
}
