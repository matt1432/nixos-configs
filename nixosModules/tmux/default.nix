{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues elemAt mkIf mkOption types;

  cfg = config.programs.tmux;

  firstUser = elemAt (attrValues config.home-manager.users) 0;
in {
  options.programs.tmux = {
    enableCustomConf = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enableCustomConf {
    environment.etc."tmux.conf".source = firstUser.xdg.configFile."tmux/tmux.conf".source;

    home-manager.sharedModules = [
      {
        programs = {
          # Make sure we have color support
          bash.shellAliases.tmux = "tmux -2";

          tmux = {
            enable = true;
            mouse = true;
            keyMode = "vi";
            terminal = "tmux-256color";
            newSession = true;
            historyLimit = 30000;

            plugins = attrValues {
              inherit (pkgs.tmuxPlugins) dracula;
            };

            extraConfig =
              # bash
              ''
                bind-key -n Home send Escape "OH"
                bind-key -n End send Escape "OF"

                bind -T root WheelUpPane   if-shell -F -t = "#{alternate_on}" "send-keys -M" "select-pane -t =; copy-mode -e; send-keys -M"
                bind -T root WheelDownPane if-shell -F -t = "#{alternate_on}" "send-keys -M" "select-pane -t =; send-keys -M"

                set -ga terminal-overrides ',xterm*:smcup@:rmcup@'
                set -ga terminal-overrides ",*256col*:Tc"
              '';
          };
        };
      }
    ];
  };
}
