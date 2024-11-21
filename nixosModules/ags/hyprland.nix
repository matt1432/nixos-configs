self: {lib, ...}: let
  inherit (lib) map;
  inherit (self.lib.hypr) mkAnimation mkBezier mkBind mkLayerRule;
in {
  config.wayland.windowManager.hyprland = {
    settings = {
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 0;
      };

      decoration = {
        rounding = 12;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        shadow.enabled = false;
      };

      animations = {
        enabled = true;

        bezier = map mkBezier [
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

        animation = map mkAnimation [
          {
            name = "workspaces";
            duration = 6;
            bezier = "easeOutQuart";
            style = "slide";
          }

          {
            name = "windows";
            duration = 4;
            bezier = "easeOutQuart";
            style = "slide";
          }
          {
            name = "fadeIn";
            enable = false;
          }
          {
            name = "fadeOut";
            duration = 4;
            bezier = "easeInExpo";
          }

          {
            name = "fadeLayersIn";
            enable = false;
          }
          {
            name = "fadeLayersOut";
            duration = 4;
            bezier = "easeInExpo";
          }
          {
            name = "layers";
            duration = 4;
            bezier = "easeInOutQuart";
            style = "fade";
          }
        ];
      };

      layerrule = map mkLayerRule [
        {
          rule = "animation popin";
          namespace = "^(hyprpaper.*)";
        }
        {
          rule = "animation fade";
          namespace = "^(bg-layer.*)";
        }
        {
          rule = "noanim";
          namespace = "^(noanim-.*)";
        }

        {
          rule = "blur";
          namespace = "^(blur-bg.*)";
        }
        {
          rule = "ignorealpha 0.19";
          namespace = "^(blur-bg.*)";
        }
      ];

      exec-once = [
        "ags"
        "sleep 3; ags request 'open win-applauncher'"
      ];

      bind = map mkBind [
        {
          modifier = "$mainMod SHIFT";
          key = "E";
          command = "ags toggle win-powermenu";
        }
        {
          modifier = "$mainMod";
          key = "D";
          command = "ags toggle win-applauncher";
        }
        {
          modifier = "$mainMod";
          key = "V";
          command = "ags toggle win-clipboard";
        }
        {
          key = "Print";
          command = "ags toggle win-screenshot";
        }

        {
          key = "XF86AudioMute";
          command = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        }
        {
          key = "XF86AudioMicMute";
          command = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        }
        {
          modifier = "$mainMod";
          key = "Print";
          command = "bash -c \"grim -g \\\"$(slurp)\\\" - | satty -f -\"";
        }
      ];

      binde = map mkBind [
        {
          key = "XF86MonBrightnessUp";
          command = "ags request 'Brightness.screen +0.05'";
        }
        {
          key = "XF86MonBrightnessDown";
          command = "ags request 'Brightness.screen -0.05'";
        }

        {
          key = "XF86AudioRaiseVolume";
          command = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ & ags request 'popup speaker' &";
        }
        {
          key = "XF86AudioLowerVolume";
          command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- & ags request 'popup speaker' &";
        }
      ];

      bindn = map mkBind [
        {
          key = "Escape";
          command = "ags request closeAll";
        }
      ];

      bindr = map mkBind [
        {
          modifier = "CAPS";
          key = "Caps_Lock";
          command = "ags request fetchCapsState";
        }
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
