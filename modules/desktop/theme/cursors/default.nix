self: {
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (self.scopedPackages.${pkgs.system}) dracula;

  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;
in {
  config = mkIf cfg.enable {
    home.pointerCursor = {
      name = "Dracula-cursors";
      package = dracula.gtk;
      size = 24;

      gtk.enable = true;
      hyprcursor.enable = true;
    };

    # Fixes Gtk4 apps complaining about mismatched cursor size
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "gsettings set org.gnome.desktop.interface cursor-size 30"
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
