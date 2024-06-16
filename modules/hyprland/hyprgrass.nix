{
  osConfig,
  hyprgrass,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) optionalAttrs;

  isTouchscreen = osConfig.hardware.sensor.iio.enable;
in
  optionalAttrs isTouchscreen {
    wayland.windowManager.hyprland = {
      plugins = [hyprgrass.packages.${pkgs.system}.default];

      settings = {
        plugin = {
          touch_gestures = {
            # The default sensitivity is probably too low on tablet screens,
            # I recommend turning it up to 4.0
            sensitivity = 4.0;

            # must be >= 3
            workspace_swipe_fingers = 3;

            experimental = {
              # send proper cancel events to windows instead of hacky touch_up events,
              # NOT recommended as it crashed a few times, once it's stabilized I'll make it the default
              send_cancel = 0;
            };
          };
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
          workspace_swipe_touch = false;
          workspace_swipe_cancel_ratio = 0.15;
        };
      };
    };
  }
