{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) optionals;
  inherit (osConfig.services.xserver) xkb;
  inherit (osConfig.vars) mainMonitor;

  razerConf = {
    sensitivity = -0.5;
    accel_profile = "flat";
  };
in {
  wayland.windowManager.hyprland = {
    settings = {
      input = {
        kb_layout = xkb.layout;
        kb_variant = xkb.variant;
        follow_mouse = true;

        touchpad = {
          natural_scroll = true;
          disable_while_typing = false;
        };
      };

      "device:razer-razer-naga-pro" = razerConf;
      "device:razer-razer-naga-pro-1" = razerConf;

      exec-once =
        optionals (! isNull mainMonitor)
        ["hyprctl dispatch focusmonitor ${mainMonitor}"];
    };
  };
}
