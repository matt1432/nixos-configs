self: {
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkBind;

  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;
in {
  # FIXME: crashes hyprland on binto
  config = mkIf (cfg.enable && cfg.isTouchscreen) {
    wayland.windowManager.hyprland = {
      plugins = [pkgs.hyprlandPlugins.hyprexpo];

      settings = {
        plugin.hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1

          enable_gesture = cfg.isTouchscreen; # laptop touchpad
          gesture_fingers = 3;
          gesture_distance = 300; # how far is the "max"
          gesture_positive = true; # positive = swipe down. Negative = swipe up.
        };

        bind = [
          (mkBind {
            modifier = "ALT";
            key = "tab";
            dispatcher = "hyprexpo:expo";
            command = "toggle"; # can be: toggle, off/disable or on/enable
          })
        ];

        # FIXME: https://github.com/hyprwm/hyprland-plugins/issues/494
        # hyprexpo-gesture = mkIf cfg.isTouchscreen ["3, vertical, expo"];
        gesture = mkIf cfg.isTouchscreen ["3, vertical, dispatcher, hyprexpo:expo, toggle"];
      };
    };
  };

  # For accurate stack trace
  _file = ./hyprexpo.nix;
}
