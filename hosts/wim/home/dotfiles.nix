{ config, pkgs, nixpkgs-wayland, ... }: let
  waypkgs = nixpkgs-wayland.packages.x86_64-linux;

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
      package = waypkgs.wofi;
      settings = {
        prompt = "";
        allow_images = true;
        normal_window = true;
        image_size = "48";
        matching = "fuzzy";
        insensitive = true;
        no_actions = true;
      };
      style = builtins.readFile ../config/wofi/style.css;
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

        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
          size = 12.5;
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
