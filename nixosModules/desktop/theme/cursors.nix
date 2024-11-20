self: {pkgs, ...}: {
  config = let
    inherit (self.scopedPackages.${pkgs.system}) dracula;

    cursorTheme = dracula.hyprcursor;
    cursorThemeName = "Dracula-cursors";
    hyprcursorThemeName = "Dracula-hyprcursor";
    cursorSize = 24;
  in {
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

    wayland.windowManager.hyprland = {
      settings = {
        envd = [
          "XCURSOR_THEME, ${cursorThemeName}"
          "XCURSOR_SIZE, ${toString cursorSize}"
        ];

        exec-once = [
          "hyprctl setcursor ${hyprcursorThemeName} ${toString cursorSize}"
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./cursors.nix;
}
