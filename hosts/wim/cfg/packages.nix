{ pkgs, hyprland, ... }:

{
  systemd.user.services.protonmail-bridge = {
    description = "Protonmail Bridge";
    enable = true;
    script = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive --log-level info";
    path = [ pkgs.gnome.gnome-keyring ]; # HACK: https://github.com/ProtonMail/proton-bridge/issues/176
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  services = {
    xserver = {
      enable = true;
      layout = "ca";
      displayManager = {
        sddm = {
          enable = true;
          settings = {
            General = {
              DisplayServer = "wayland";
              InputMethod = "";
            };
            Wayland.CompositorCommand = "${pkgs.weston}/bin/weston --shell=fullscreen-shell.so";
            Theme = {
              Current = "Dracula";
              CursorTheme = "Dracula-cursors";
              CursorSize = 24;
            };
          };
        };
        sessionPackages = [
          hyprland.packages.x86_64-linux.default
        ];
        defaultSession = "hyprland";
        autoLogin = {
          enable = true;
          user = "matt";
        };
      };
      libinput.enable = true;
    };
    dbus.enable = true;
    gvfs.enable = true;
    flatpak.enable = true;
    tlp.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
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

  # List packages in root user PATH
  environment.systemPackages = with pkgs; [
    # for sddm
    plasma5Packages.plasma-framework
    plasma5Packages.plasma-workspace

    qemu
    wl-clipboard
    alsa-utils
    evtest
    plasma5Packages.kio-admin
    plasma5Packages.ksshaskpass
  ];
}
