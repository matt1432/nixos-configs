{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) genAttrs optionals;
  inherit (osConfig.services.xserver) xkb;
  inherit (osConfig.vars) mainMonitor;

  nagaProNames = [
    # Wireless
    "device:razer-razer-naga-pro"

    # Wired (it always changes)
    "device:razer-razer-naga-pro-1"
    "device:razer-naga-pro"
    "device:razer-naga-pro-1"
    "device:razer-naga-pro-2"
    "device:razer-naga-pro-3"
  ];
  nagaConf = {
    sensitivity = 0;
  };
in {
  wayland.windowManager.hyprland = {
    settings =
      (genAttrs nagaProNames (n: nagaConf))
      // {
        input = {
          kb_layout = xkb.layout;
          kb_variant = xkb.variant;
          follow_mouse = true;
          accel_profile = "flat";

          touchpad = {
            natural_scroll = true;
            disable_while_typing = false;
          };
        };

        exec-once =
          optionals (! isNull mainMonitor)
          ["hyprctl dispatch focusmonitor ${mainMonitor}"];
      };
  };
}
