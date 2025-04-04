self: {
  osConfig,
  lib,
  ...
}: let
  inherit (self.lib.hypr) mkBind;

  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;

  inherit (osConfig.services.xserver) xkb;

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
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        device = map mkConf miceNames;

        cursor = {
          no_hardware_cursors = osConfig.nvidia.enable;
          hide_on_touch = true;
        };

        exec-once =
          if cfg.mainMonitor != null
          then ["hyprctl dispatch focusmonitor ${cfg.mainMonitor}"]
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

        bind = map mkBind [
          {
            key = "XF86AudioPlay";
            command = "playerctl play-pause";
          }
          {
            key = "XF86AudioStop";
            command = "playerctl stop";
          }
          {
            key = "XF86AudioNext";
            command = "playerctl next";
          }
          {
            key = "XF86AudioPrev";
            command = "playerctl previous";
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./inputs.nix;
}
