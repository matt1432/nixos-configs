{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;
in {
  config = mkIf cfg.enable {
    programs = {
      # https://codeberg.org/dnkl/foot/wiki#spawning-new-terminal-instances-in-the-current-working-directory
      bash.bashrcExtra =
        # bash
        ''
          osc7_cwd() {
              local strlen=''${#PWD}
              local encoded=""
              local pos c o
              for (( pos=0; pos<strlen; pos++ )); do
                  c=''${PWD:$pos:1}
                  case "$c" in
                      [-/:_.!\'\(\)~[:alnum:]] ) o="$c" ;;
                      * ) printf -v o '%%%02X' "'$c" ;;
                  esac
                  encoded+="''${o}"
              done
              printf '\e]7;file://%s%s\e\\' "''${HOSTNAME}" "''${encoded}"
          }
          PROMPT_COMMAND=''${PROMPT_COMMAND:+$PROMPT_COMMAND; }osc7_cwd
        '';

      foot = {
        enable = true;

        settings = {
          main = {
            term = "xterm-256color";

            font = "${cfg.fontName}:size=${
              lib.strings.floatToString cfg.fontSize
            }";
            pad = "0x10";
          };

          key-bindings = {
            spawn-terminal = "Control+Shift+Return";
          };

          bell = {
            urgent = false;
            notify = false;
            visual = false;
            command = null;
            command-focused = false;
          };

          colors = {
            # BG transparency
            alpha = 0.8;

            background = "282a36";
            foreground = "f8f8f2";

            regular0 = "21222c"; # black
            regular1 = "ff5555"; # red
            regular2 = "50fa7b"; # green
            regular3 = "f1fa8c"; # yellow
            regular4 = "bd93f9"; # blue
            regular5 = "ff79c6"; # magenta
            regular6 = "8be9fd"; # cyan
            regular7 = "f8f8f2"; # white

            bright0 = "6272a4"; # bright black
            bright1 = "ff6e6e"; # bright red
            bright2 = "69ff94"; # bright green
            bright3 = "ffffa5"; # bright yellow
            bright4 = "d6acff"; # bright blue
            bright5 = "ff92df"; # bright magenta
            bright6 = "a4ffff"; # bright cyan
            bright7 = "ffffff"; # bright white

            selection-foreground = "ffffff";
            selection-background = "44475a";

            urls = "8be9fd";
          };
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./foot.nix;
}
