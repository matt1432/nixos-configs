{osConfig, ...}: {
  config = let
    inherit (osConfig.services.xserver) xkb;
    inherit (osConfig.roles.desktop) mainMonitor;

    miceNames = [
      "logitech-g502-x"
      "logitech-g502-hero-gaming-mouse"
    ];

    mkConf = name: {
      inherit name;
      sensitivity = 0;
      accel_profile = "flat";
    };
  in {
    wayland.windowManager.hyprland = {
      settings = {
        device = map (d: (mkConf d)) miceNames;

        cursor = {
          no_hardware_cursors = osConfig.nvidia.enable;
          hide_on_touch = true;
        };

        exec-once =
          if mainMonitor != null
          then ["hyprctl dispatch focusmonitor ${mainMonitor}"]
          else [];

        input = {
          # Keyboard
          kb_layout = xkb.layout;
          kb_variant = xkb.variant;
          numlock_by_default = true;
          repeat_rate = 25;

          # Mouse
          follow_mouse = true;

          # Touchpad
          touchpad = {
            natural_scroll = true;
            disable_while_typing = false;
            drag_lock = true;
            tap-and-drag = true;
          };
        };

        bind = [
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioStop, exec, playerctl stop"
          ",XF86AudioNext, exec, playerctl next"
          ",XF86AudioPrev, exec, playerctl previous"
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./inputs.nix;
}
