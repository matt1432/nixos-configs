{ pkgs, ... }: {
  services = {

    fwupd.enable = true;
    upower.enable = true;

    locate = {
      enable = true;
      package = pkgs.mlocate;
      localuser = null;
      interval = "hourly";
      prunePaths = [
        "/tmp"
        "/var/tmp"
        "/var/cache"
        "/var/lock"
        "/var/run"
        "/var/spool"
        "/nix/var/log/nix"
        "/proc"
        "/run/user"
      ];
    };
  };

  programs = {
    # TODO: install plugins through nix
    tmux = {
      enable = true;
      keyMode = "vi";
      terminal = "screen-256color";
      newSession = true;
      historyLimit = 30000;
      extraConfig = ''
        bind-key -n Home send Escape "OH"
        bind-key -n End send Escape "OF"
        set -g mouse on
        set -ga terminal-overrides ',xterm*:smcup@:rmcup@'
        bind -T root WheelUpPane   if-shell -F -t = "#{alternate_on}" "send-keys -M" "select-pane -t =; copy-mode -e; send-keys -M"
        bind -T root WheelDownPane if-shell -F -t = "#{alternate_on}" "send-keys -M" "select-pane -t =; send-keys -M"

        set -g @plugin 'dracula/tmux'
        run 'bash -c "$HOME/.tmux/plugins/tpm/tpm ||
                      ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm &&
                      $HOME/.tmux/plugins/tpm/tpm"'
      '';
    };
  };
}
