self: {
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkBezier mkBind mkExecOnce;

  inherit (lib) getExe mkIf;

  cfgDesktop = osConfig.roles.desktop;
in {
  config = mkIf cfgDesktop.ags.enable {
    wayland.windowManager.hyprland = {
      settings = {
        config = {
          general = {
            gaps_in = 5;
            gaps_out = 5;
            border_size = 0;
          };

          animations.enabled = true;

          decoration = {
            rounding = 12;

            blur = {
              enabled = true;
              size = 3;
              passes = 1;
            };

            shadow.enabled = false;
          };

          misc.session_lock_xray = true;
        };

        curve = map mkBezier [
          {
            name = "easeInQuart";
            p0 = [0.895 0.030];
            p1 = [0.685 0.220];
          }
          {
            name = "easeOutQuart";
            p0 = [0.165 0.840];
            p1 = [0.440 1.000];
          }
          {
            name = "easeInOutQuart";
            p0 = [0.770 0.000];
            p1 = [0.175 1.000];
          }

          # fade out
          {
            name = "easeInExpo";
            p0 = [0.950 0.050];
            p1 = [0.795 0.035];
          }
        ];

        animation = [
          {
            leaf = "workspaces";
            enabled = true;
            speed = 6;
            bezier = "easeOutQuart";
            style = "slide";
          }

          {
            leaf = "windows";
            enabled = true;
            speed = 4;
            bezier = "easeOutQuart";
            style = "slide";
          }
          {
            leaf = "fadeIn";
            enabled = false;
          }
          {
            leaf = "fadeOut";
            enabled = true;
            speed = 4;
            bezier = "easeInExpo";
          }

          {
            leaf = "fadeLayersIn";
            enabled = false;
          }
          {
            leaf = "fadeLayersOut";
            enabled = true;
            speed = 4;
            bezier = "easeInExpo";
          }
          {
            leaf = "layers";
            enabled = true;
            speed = 4;
            bezier = "easeInOutQuart";
            style = "fade";
          }
        ];

        layer_rule = [
          {
            match.namespace = "^(hyprpaper.*)";
            animation = "popin";
          }
          {
            match.namespace = "^(bg-layer.*)";
            animation = "fade";
          }
          {
            match.namespace = "^(noanim-.*)";
            no_anim = true;
          }
          {
            match.namespace = "^(blur-bg.*)";
            blur = true;
            ignore_alpha = 0.19;
          }
        ];

        on = map mkExecOnce [
          # lua
          ''
            hl.exec_cmd("ags")
            hl.exec_cmd("sleep 3; ags request 'open win-applauncher'")
          ''
        ];

        bind = map mkBind [
          {
            keys = "SUPER + SHIFT + E";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("ags toggle win-powermenu")
              '';
          }
          {
            keys = "SUPER + D";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("ags toggle win-applauncher")
              '';
          }
          {
            keys = "SUPER + V";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("ags toggle win-clipboard")
              '';
          }
          {
            keys = "Print";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("ags toggle win-screenshot")
              '';
          }

          {
            keys = "XF86AudioMute";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle")
              '';
          }
          {
            keys = "XF86AudioMicMute";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
              '';
          }
          {
            keys = "SUPER + Print";
            dispatcher = let
              command = getExe (pkgs.writeShellApplication {
                name = "select-screenshot";
                runtimeInputs = with pkgs; [grim-hyprland satty slurp];
                text = ''
                  grim -g "$(slurp)" - | satty -f -
                '';
              });
            in
              # lua
              ''
                hl.dsp.exec_cmd("${command}")
              '';
          }

          {
            keys = "XF86MonBrightnessUp";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("ags request 'Brightness.screen +0.05'")
              '';
            flags.repeating = true;
          }
          {
            keys = "XF86MonBrightnessDown";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("ags request 'Brightness.screen -0.05'")
              '';
            flags.repeating = true;
          }

          {
            keys = "XF86AudioRaiseVolume";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ & ags request 'popup speaker' &")
              '';
            flags.repeating = true;
          }
          {
            keys = "XF86AudioLowerVolume";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- & ags request 'popup speaker' &")
              '';
            flags.repeating = true;
          }

          {
            keys = "Escape";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("ags request closeAll")
              '';
            flags.non_consuming = true;
          }

          {
            keys = "CAPS + Caps_Lock";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("ags request fetchCapsState")
              '';
            flags.release = true;
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
