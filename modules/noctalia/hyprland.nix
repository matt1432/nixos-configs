self: {
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkAnimation mkBezier mkBind mkLayerRule;

  inherit (lib) getExe mkIf;

  cfgDesktop = osConfig.roles.desktop;
in {
  config = mkIf cfgDesktop.noctalia.enable {
    wayland.windowManager.hyprland = {
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

        misc.session_lock_xray = true;

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
        ];

        exec-once = [
          "hyprpaper"
          "noctalia-shell"
          "sleep 3; noctalia-shell ipc call launcher toggle"
        ];

        bind = map mkBind [
          {
            modifier = "$mainMod SHIFT";
            key = "E";
            command = "noctalia-shell ipc call sessionMenu toggle";
          }
          {
            modifier = "$mainMod";
            key = "D";
            command = "noctalia-shell ipc call launcher toggle";
          }
          {
            modifier = "$mainMod";
            key = "V";
            command = "noctalia-shell ipc call launcher clipboard";
          }
          {
            key = "Print";
            # TODO:
            command = "ags toggle win-screenshot";
          }

          {
            key = "XF86AudioMute";
            command = "noctalia-shell ipc call volume muteOutput";
          }
          {
            key = "XF86AudioMicMute";
            command = "noctalia-shell ipc call volume muteInput";
          }
          {
            modifier = "$mainMod";
            key = "Print";
            command = getExe (pkgs.writeShellApplication {
              name = "select-screenshot";
              runtimeInputs = with pkgs; [grim-hyprland satty slurp];
              text = ''
                grim -g "$(slurp)" - | satty -f -
              '';
            });
          }
        ];

        binde = map mkBind [
          {
            key = "XF86MonBrightnessUp";
            command = "noctalia-shell ipc call brightness increase";
          }
          {
            key = "XF86MonBrightnessDown";
            command = "noctalia-shell ipc call brightness decrease";
          }

          {
            key = "XF86AudioRaiseVolume";
            command = "noctalia-shell ipc call volume increase";
          }
          {
            key = "XF86AudioLowerVolume";
            command = "noctalia-shell ipc call volume decreaseInput";
          }
        ];

        bindn = map mkBind [
          {
            key = "Escape";
            # TODO:
            command = "ags request closeAll";
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./hyprland.nix;
}
