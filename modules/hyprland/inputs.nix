{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) optionals;
  inherit (osConfig.services.xserver) xkb;
  inherit (osConfig.vars) mainMonitor;

  miceNames = [
    # Wireless
    "razer-razer-naga-pro"

    # Wired (it always changes)
    "razer-razer-naga-pro-1"
    "razer-naga-pro"
    "razer-naga-pro-1"
    "razer-naga-pro-2"
    "razer-naga-pro-3"
    "logitech-g502-hero-gaming-mouse"
  ];
  nagaConf = name: {
    inherit name;
    sensitivity = 0;
    accel_profile = "flat";
  };
in {
  wayland.windowManager.hyprland = {
    settings = {
      device = map (d: (nagaConf d)) miceNames;

      input = {
        kb_layout = xkb.layout;
        kb_variant = xkb.variant;
        follow_mouse = true;

        touchpad = {
          natural_scroll = true;
          disable_while_typing = false;
        };
      };

      bind = [
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioStop, exec, playerctl stop"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];

      exec-once =
        optionals (! isNull mainMonitor)
        ["hyprctl dispatch focusmonitor ${mainMonitor}"];
    };
  };
}
