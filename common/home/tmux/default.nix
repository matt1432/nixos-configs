{pkgs, ...}: {
  programs = {
    tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
      terminal = "tmux-256color";
      newSession = true;
      historyLimit = 30000;

      plugins = with pkgs.tmuxPlugins; [
        dracula
      ];

      extraConfig = ''
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
