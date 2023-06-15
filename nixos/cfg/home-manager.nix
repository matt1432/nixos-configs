{ config, ... }:

{
  imports =
    [
      <home-manager/nixos>
    ];

  home-manager.useGlobalPkgs = true;
  programs.dconf.enable = true;

  home-manager.users.matt = { config, pkgs, lib, ... }: let
    flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

    hyprland = (import flake-compat {
                                                                              # I use release version for plugin support
      src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/v0.26.0.tar.gz";
    }).defaultNix;

  in {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    };
    
    home.packages = with pkgs; [ 
      libsForQt5.qtstyleplugin-kvantum
      alacritty
      brightnessctl
      pulseaudio
      alsa-utils
      wget
      firefox
      tree
      mlocate
      gcc
      rsync
      tmux
      git
      git-lfs
      killall
      htop
      fzf
      jq
      ripgrep
      hyprpaper
      python3
      rofi-wayland
      wev
      networkmanagerapplet
      nextcloud-client
      tutanota-desktop
      galaxy-buds-client
      gnome.gnome-calculator
      swaynotificationcenter
      #swayosd
      (with import <nixpkgs> {}; callPackage ./swayosd.nix {})
      swayidle
      wl-clipboard
      cliphist
      polkit-kde-agent
      gtklock
      gtklock-playerctl-module
      gtklock-powerbar-module
      grim
      slurp
      swappy
      gnome.seahorse
      neovim
      fontfor
      qt5ct
      lxappearance
      gnome3.adwaita-icon-theme
      xorg.xcursorthemes
      imagemagick
      usbutils
      catppuccin-plymouth
      evtest
      squeekboard
      glib
      appimage-run
    ];

    home.sessionVariables = {
      XDG_DATA_DIRS = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:\$XDG_DATA_DIRS";
    };

    imports = [
     hyprland.homeManagerModules.default
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      
      plugins = with pkgs; [
        /nix/store/60x0zlg3fbq7nzz8249fxsb89pn541z8-hyprland-touch-gestures-0.3.0/lib/libtouch-gestures.so
      ];

      extraConfig = ''
        source = ~/.config/hypr/main.conf
        env = XDG_DATA_DIRS, ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS
      '';
    };

    home.stateVersion = "23.05";
  };
}
