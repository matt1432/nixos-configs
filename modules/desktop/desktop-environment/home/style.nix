{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkIf;

  cursorTheme = self.legacyPackages.${pkgs.system}.dracula.hyprcursor;
  cursorThemeName = "Dracula-cursors";
  hyprcursorThemeName = "Dracula-hyprcursor";
  cursorSize = "24";
in {
  imports = [
    ../../home/theme
    ../../home/hyprpaper.nix
  ];

  home.file.".local/share/icons/${hyprcursorThemeName}".source = cursorTheme;

  wayland.windowManager.hyprland = {
    settings =
      {
        envd = [
          "XCURSOR_THEME, ${cursorThemeName}"
          "XCURSOR_SIZE, ${cursorSize}"
        ];

        exec-once = [
          "hyprctl setcursor ${hyprcursorThemeName} ${cursorSize}"
        ];

        windowrule = [
          "size 1231 950,title:^(Open Folder)$"
          "float,title:^(Open Folder)$"

          "size 1231 950,title:^(Open File)$"
          "float,title:^(Open File)$"
        ];

        layerrule = [
          "noanim, selection"
        ];
      }
      // (
        mkIf (config.home.username != "greeter") {
          # This file should only be used for theming
          source = ["${config.vars.configDir}/hypr/main.conf"];
        }
      );
  };
}
