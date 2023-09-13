{ config, ... }:

let
  configDir = "/home/matt/.nix/config";
in

{
  xdg.configFile = {
    "swayosd/style.css".source  = config.lib.file.mkOutOfStoreSymlink "${configDir}/swayosd/style.css";

    "gtklock/config.ini".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/gtklock/config.ini";
    "gtklock/style.css".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/gtklock/style.css";

    "ags".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/ags";

    "ripgrep".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/ripgrep";

    "discord/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/discord/settings.json";

    "dolphinrc".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/dolphinrc";
    "kdeglobals".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/kdeglobals";
    "kiorc".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/kiorc";
  };

  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    eww = {
      enable = true;
      configDir = config.lib.file.mkOutOfStoreSymlink "${configDir}/eww"; # see hyprland.nix for scripts path
      package = (builtins.getFlake "github:matt1432/eww-exclusiver").packages.x86_64-linux.default;
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
