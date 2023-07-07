{config, pkgs, ...}:

{
  services = {
    xserver = {
      enable = true;
      layout = "ca";
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
        sessionPackages = [
          pkgs.gnome.gnome-session.sessions # gnome session needed to fix bugs
          (builtins.getFlake "github:hyprwm/Hyprland").packages.x86_64-linux.default
        ];
        defaultSession = "hyprland";
        #autoLogin = { # logs out after a minute
        #  enable = true;
        #  user = "matt";
        #};
      };
      libinput.enable = true;
    };
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
        "/run/user/1000"
      ];
    };
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

    git = { # TODO: make better config
      enable = true;
      lfs.enable = true;
      config = {
        # Dracula Dark Theme
        color = {
          ui = "auto";
          branch = {
            current = "cyan bold reverse";
            local = "white";
            plain = "";
            remote = "cyan";
          };
          diff = {
            commit = "";
            func = "cyan";
            plain = "";
            whitespace = "magenta reverse";
            meta = "white";
            frag = "cyan bold reverse";
            old = "red";
            new = "green";
          };
          grep = {
            context = "";
            filename = "";
            function = "";
            linenumber = "white";
            match = "";
            selected = "";
            separator = "";
          };
          interactive = {
            error = "";
            header = "";
            help = "";
            prompt = "";
          };
          status = {
            added = "green";
            changed = "yellow";
            header = "";
            localBranch = "";
            nobranch = "";
            remoteBranch = "cyan bold";
            unmerged = "magenta bold reverse";
            untracked = "red";
            updated = "green bold";
          };
        };
      };
    };

    htop = {
      enable = true;
    };

    fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };
  };

  # List packages in root user PATH
  environment.systemPackages = with pkgs; [
    wl-clipboard
    alsa-utils
    wget
    tree
    rsync
    killall
    ripgrep-all
    neovim # TODO: use nix
    imagemagick
    usbutils
    evtest
    plasma5Packages.kio-admin
    plasma5Packages.ksshaskpass
  ];

  fonts = {
    fontconfig = {
      enable = true;
      /*defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "MesloLGS Nerd Font" ];
        sansSerif = [ "MesloLGS Nerd Font" ];
        serif = [ "MesloLGS Nerd Font" ];
      };*/
    };

    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "Go-Mono" "Iosevka" "NerdFontsSymbolsOnly" "SpaceMono" "Ubuntu" ]; })
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      font-awesome
      meslo-lgs-nf
      jetbrains-mono
      ubuntu_font_family
    ];
  };
}
