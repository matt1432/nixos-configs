{ config, ... }:

let
  configDir = "/home/matt/.nix/configs";
in

{
  xdg.configFile = {
    "swaync/config.json".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/swaync/config.json";
    "swaync/style.css".source   = config.lib.file.mkOutOfStoreSymlink "${configDir}/swaync/style.css";
  };

  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
      #colors = {
        # not working ?
      #};
    };

    eww = {
      enable = true;
      configDir = config.lib.file.mkOutOfStoreSymlink "${configDir}/eww"; # see hyprland.nix for scripts path
      package = (builtins.getFlake "github:matt1432/eww-exclusiver").packages.x86_64-linux.default;
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

          opacity = 0.6;
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
