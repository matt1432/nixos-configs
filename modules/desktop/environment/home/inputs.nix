self: {
  osConfig,
  lib,
  ...
}: let
  inherit (self.lib.hypr) mkBind mkExecOnce;

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

        config = {
          cursor = {
            no_hardware_cursors = osConfig.nvidia.enable;
            hide_on_touch = true;
          };

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
              tap_and_drag = true;
            };
          };
        };

        on =
          if cfg.mainMonitor != null
          then
            map mkExecOnce [
              # lua
              ''
                hl.dsp.focus({ monitor = "${cfg.mainMonitor}" })
              ''
            ]
          else [];

        bind = map mkBind [
          {
            keys = "XF86AudioPlay";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("playerctl play-pause")
              '';
          }
          {
            keys = "XF86AudioStop";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("playerctl stop")
              '';
          }
          {
            keys = "XF86AudioNext";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("playerctl next")
              '';
          }
          {
            keys = "XF86AudioPrev";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("playerctl previous")
              '';
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./inputs.nix;
}
