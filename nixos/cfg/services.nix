{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "ca";
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };                        # gnome session needed to fix bugs
      sessionPackages = [ pkgs.gnome.gnome-session.sessions ];
      # See ./cfg/home-manager.nix
      #defaultSession = "hyprland";
      #autoLogin = { # logs out after a minute
      #  enable = true;
      #  user = "matt";
      #};
    };
    libinput.enable = true;
  };

  xdg.portal.enable = true;
 
  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
  };

  services = {
    dbus.enable = true;
    flatpak.enable = true;
    tlp.enable = true;

    locate = {
      enable = true;
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
      ];
    };
  };

  programs = {

    waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    };

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
      '';
    };
  
    git = { # TODO: make better config
      enable = true;
      lfs.enable = true;
    };

    htop = {
      enable = true;
    };

    fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };
  };
}
