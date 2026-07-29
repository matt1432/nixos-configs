self: {
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;
in {
  config = mkIf (cfg.enable && cfg.isTouchscreen) {
    wayland.windowManager.hyprland = {
      plugins = [
        pkgs.hyprlandPlugins.hyprgrass
        pkgs.hyprlandPlugins.touchpos
      ];

      settings = {
        config = {
          gestures = {
            workspace_swipe_touch = true;
            workspace_swipe_cancel_ratio = 0.15;
          };

          plugin.hyprgrass = {
            # The default sensitivity is probably too low on tablet screens,
            # I recommend turning it up to 4.0
            sensitivity = 4.0;

            # in milliseconds
            long_press_delay = 400;

            # resize windows by long-pressing on window borders and gaps.
            # If general:resize_on_border is enabled, general:extend_border_grab_area is used for floating
            # windows
            resize_on_border_long_press = true;

            # in pixels, the distance from the edge that is considered an edge
            edge_margin = 10;
          };
        };

        gesture = [
          {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          }
        ];
      };

      extraConfig =
        # lua
        ''
          hl.plugin.hyprgrass.bind({
              pattern = { kind = "longpress", fingers = 2 },
              action = hl.dsp.window.drag(),
              mouse = true,
          });

          hl.plugin.hyprgrass.bind({
              pattern = { kind = "edge", origin = "u", direction = "d" },
              action = hl.dsp.exec_cmd("ags request 'open win-applauncher'"),
          });
        '';
    };
  };

  # For accurate stack trace
  _file = ./hyprgrass.nix;
}
