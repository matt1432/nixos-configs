self: {
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (self.scopedPackages.${pkgs.system}) dracula;

  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;

  cursorTheme = dracula.hyprcursor;
  cursorThemeName = "Dracula-cursors";
  hyprcursorThemeName = "Dracula-hyprcursor";
  cursorSize = 24;
in {
  config = mkIf cfg.enable {
    home.pointerCursor = {
      name = cursorThemeName;
      package = dracula.gtk;
      size = cursorSize;

      gtk.enable = true;

      x11 = {
        enable = true;
        defaultCursor = cursorThemeName;
      };
    };

    home.file.".local/share/icons/${hyprcursorThemeName}".source = cursorTheme;

    wayland.windowManager.hyprland.settings = {
      envd = [
        "XCURSOR_THEME, ${cursorThemeName}"
        "XCURSOR_SIZE, ${toString cursorSize}"
      ];

      exec-once = [
        "hyprctl setcursor ${hyprcursorThemeName} ${toString cursorSize}"
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
