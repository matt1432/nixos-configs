self: {
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) map mkIf;
  inherit (self.lib.hypr) mkBind;

  cfg = osConfig.roles.desktop;
in {
  config = mkIf cfg.isTouchscreen {
    wayland.windowManager.hyprland = {
      plugins = [self.inputs.hyprgrass.packages.${pkgs.system}.default];

      settings = {
        plugin.touch_gestures = {
          # The default sensitivity is probably too low on tablet screens,
          # I recommend turning it up to 4.0
          sensitivity = 4.0;

          # must be >= 3
          workspace_swipe_fingers = 3;

          # switching workspaces by swiping from an edge, this is separate from workspace_swipe_fingers
          # and can be used at the same time
          # possible values: l, r, u, or d
          # to disable it set it to anything else
          # workspace_swipe_edge = "d";

          # in milliseconds
          long_press_delay = 400;

          # resize windows by long-pressing on window borders and gaps.
          # If general:resize_on_border is enabled, general:extend_border_grab_area is used for floating
          # windows
          resize_on_border_long_press = true;

          # in pixels, the distance from the edge that is considered an edge
          edge_margin = 10;

          # send proper cancel events to windows instead of hacky touch_up events,
          # NOT recommended as it crashed a few times, once it's stabilized I'll make it the default
          experimental.send_cancel = 0;

          hyprgrass-bind = map mkBind [
            {
              key = "edge:u:d";
              command = "ags request 'open win-applauncher'";
            }
          ];

          hyprgrass-bindm = map mkBind [
            {
              key = "longpress:2";
              dispatcher = "movewindow";
            }
          ];
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
          workspace_swipe_touch = false;
          workspace_swipe_cancel_ratio = 0.15;
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./hyprgrass.nix;
}
