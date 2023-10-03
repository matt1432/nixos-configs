{ config, pkgs, ... }: let
  configDir = (import ../vars.nix).configDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  xdg.configFile = {
    "swayosd/style.css".source     = symlink "${configDir}/swayosd/style.css";

    "gtklock/config.ini".source    = pkgs.writeText "config.ini" ''
      [main]
      modules=${builtins.concatStringsSep ";" [
        "${pkgs.gtklock-powerbar-module}/lib/gtklock/powerbar-module.so"
        "${pkgs.gtklock-playerctl-module}/lib/gtklock/playerctl-module.so"
      ]}
                                    '';
    "gtklock/style.css".source     = symlink "${configDir}/gtklock/style.css";

    "ripgrep".source               = symlink "${configDir}/ripgrep";

    "discord/settings.json".source = symlink "${configDir}/discord/settings.json";

    "dolphinrc".source             = symlink "${configDir}/dolphinrc";
    "kdeglobals".source            = symlink "${configDir}/kdeglobals";
    "kiorc".source                 = symlink "${configDir}/kiorc";
    "mimeapps.list".source         = symlink "${configDir}/mimeapps.list";
    "neofetch".source              = symlink "${configDir}/neofetch";
    "swappy".source                = symlink "${configDir}/swappy";
  };

  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    wofi = {
      enable = true;
      settings = {
        prompt = "";
        allow_images = true;
        image_size = "48";
        matching = "fuzzy";
        insensitive = true;
        normal_window = true;
        height = "620";
      };
      style = ''
        /* https://github.com/dracula/wofi/blob/master/style.css */
        window {
          margin: 0px;
          border: 1px solid #bd93f9;
          border-bottom: none;
          border-radius: 30px;
          background-color: #282a36;
        }

        #input {
          margin: 5px;
          border: none;
          color: #f8f8f2;
          background-color: #44475a;
        }

        #inner-box {
          margin: 5px;
          border: none;
          background-color: #282a36;
        }

        #outer-box {
          margin: 5px;
          padding: 10px 10px 0px 10px;
          border: none;
          border-radius: 30px;
          background-color: #282a36;
        }

        #scroll {
          margin: -4px 0px -7px 0px;
          border: none;
        }

        #text {
          margin: 5px;
          border: none;
          color: #f8f8f2;
        }

        #entry.activatable #text {
          color: #282a36;
        }

        #entry > * {
          color: #f8f8f2;
          padding: 4px 0px 0px 0px;
        }

        #entry:selected {
          background-color: #44475a;
          outline: none;
        }

        #entry:selected #text {
          font-weight: bold;
        }
      '';
    };

    alacritty = {
      enable = true;
      settings = {
        env = {
          POKE = "true";
        };

        window = {
          padding = {
            x = 0;
            y = 10;
          };

          opacity = 0.8;
        };

        # https://github.com/dracula/alacritty/blob/05faff15c0158712be87d200081633d9f4850a7d/dracula.yml
        colors = {
          primary = {
            background = "#282a36";
            foreground = "#f8f8f2";
            bright_foreground = "#ffffff";
          };
          cursor = {
            text = "CellBackground";
            cursor = "CellForeground";
          };
          vi_mode_cursor = {
            text = "CellBackground";
            cursor = "CellForeground";
          };
          search = {
            matches = {
              foreground = "#44475a";
              background = "#50fa7b";
            };
            focused_match = {
              foreground = "#44475a";
              background = "#ffb86c";
            };
            footer_bar = {
              background = "#282a36";
              foreground = "#f8f8f2";
            };
          };
          hints = {
            start = {
              foreground = "#282a36";
              background = "#f1fa8c";
            };
            end = {
              foreground = "#f1fa8c";
              background = "#282a36";
            };
          };
          line_indicator = {
            foreground = "None";
            background = "None";
          };
          selection = {
            text = "CellForeground";
            background = "#44475a";
          };
          normal = {
            black = "#21222c";
            red = "#ff5555";
            green = "#50fa7b";
            yellow = "#f1fa8c";
            blue = "#bd93f9";
            magenta = "#ff79c6";
            cyan = "#8be9fd";
            white = "#f8f8f2";
          };
        };
      };
    };
  };
}
