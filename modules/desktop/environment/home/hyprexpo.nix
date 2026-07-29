self: {
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf optionalString;

  cfg = osConfig.roles.desktop;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      plugins = [pkgs.hyprlandPlugins.hyprexpo];

      settings = {
        config.plugin.hyprexpo = {
          columns = 3;
          gaps_in = 5;
          gaps_out = 0;
          bg_col = "rgb(111111)";
          workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1

          gesture_distance = 300;
          show_cursor = 1;
        };
      };

      extraConfig =
        optionalString cfg.isTouchscreen
        # lua
        ''
          hl.plugin.hyprexpo.gesture({
              fingers = 3,
              direction = "up",
              action = "expo",
          });
          hl.plugin.hyprgrass.gesture({
              pattern = { kind = "swipe", fingers = 3, direction = "up" },
              action = "emulate_touchpad",
              emulate_fingers = 3,
              emulate_direction = "up",
          });
        ''
        +
        # lua
        ''
          hl.bind("ALT + tab", function()
              hl.plugin.hyprexpo.expo("toggle")
          end);
        '';
    };
  };

  # For accurate stack trace
  _file = ./hyprexpo.nix;
}
