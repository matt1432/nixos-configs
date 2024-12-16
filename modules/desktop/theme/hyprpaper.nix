self: {
  lib,
  pkgs,
  ...
}: {
  config = let
    hyprpaper = self.inputs.hyprpaper.packages.${pkgs.system}.default;
    wallpaper = toString self.scopedPackages.${pkgs.system}.dracula.wallpaper;
  in {
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
  _file = ./hyprpaper.nix;
}
