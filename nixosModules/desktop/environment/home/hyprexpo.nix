hyprland-plugins: {pkgs, ...}: {
  config = {
    wayland.windowManager.hyprland = {
      plugins = [hyprland-plugins.packages.${pkgs.system}.hyprexpo];

      settings = {
        plugin = {
          hyprexpo = {
            columns = 3;
            gap_size = 5;
            bg_col = "rgb(111111)";
            workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1

            enable_gesture = true; # laptop touchpad
            gesture_fingers = 3;
            gesture_distance = 300; # how far is the "max"
            gesture_positive = true; # positive = swipe down. Negative = swipe up.
          };
        };

        bind = [
          "ALT, tab, hyprexpo:expo, toggle" # can be: toggle, off/disable or on/enable
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./hyprexpo.nix;
}
