{
  lib,
  pkgs,
  self,
  ...
}: let
  wallpaper = toString self.legacyPackages.${pkgs.system}.dracula.wallpaper;
in {
  home.packages = with pkgs; [hyprpaper];

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
}
