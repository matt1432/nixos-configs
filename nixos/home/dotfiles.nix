{ ... }:

let
  configDir = "/home/matt/.nix/configs";
in

{
  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
      colors = {
        fg = "ffffff";
        bg = "4b5263";
        hl = "d858fe";
        "fg+" = "#ffffff";
        "bg+" = "#4b5263";
        "hl+" = "#d858fe";
        info = "#98c379";
        prompt = "#61afef";
        pointer = "#be5046";
        marker = "#e5c07b";
        spinner = "#61afef";
        header = "#61afef";
      };
    };

    eww = {
      enable = true;
      configDir = "${configDir}/eww"; # see hyprland.nix for scripts path
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

          opacity = 0.8;
        };

        colors = {
          primary = {
            background = "0x0c0c0c";
            foreground = "0xfcfcfc";

            dim_foreground    = "0xeff0f1";
            bright_foreground = "0xffffff";
            dim_background    = "0x31363b";
            bright_background = "0x000000";
          };
          normal = {
            black   = "0x232627";
            red     = "0xed1515";
            green   = "0x11d116";
            yellow  = "0xf67400";
            blue    = "0x1d99f3";
            magenta = "0x9b59b6";
            cyan    = "0x1abc9c";
            white   = "0xfcfcfc";
          };
        };
      };
    };
  };
}
