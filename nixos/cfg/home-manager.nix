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
    
    home.packages = with pkgs; 
      (with xorg; [
        xhost # for gparted
        xcursorthemes

      ]) ++
      (with python311Packages; [
        pyclip

      ]) ++
      (with plasma5Packages; [
        qtstyleplugin-kvantum
        breeze-icons
        dolphin # install plugins
        kio-admin # dbus issues

      ]) ++
      (with gnome; [
        gnome-calculator
        seahorse
        adwaita-icon-theme

      ]) ++
    [
      swayosd
      httrack
      lisgd
      zeal
      acpi
      libreoffice-fresh # TODO: add spelling stuff
      neofetch
      photoqt
      progress
      tlp
      wl-color-picker # add bind for this in hyprland
      xclip
      xdg-utils
      zathura # set default
      pavucontrol # TODO: open on left click
      gimp-with-plugins
      gparted # doesn't open without sudo
      jdk8_headless
      bluez-tools
      spotify
      #spotifywm # fails to build
      spotify-tray # doesn't open
      spicetify-cli # TODO
      vlc
      discord
      alacritty
      brightnessctl
      pulseaudio
      alsa-utils
      wget
      firefox
      tree
      mlocate
      mosh
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
      networkmanagerapplet
      nextcloud-client
      tutanota-desktop
      galaxy-buds-client
      swaynotificationcenter
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
      neovim
      fontfor
      qt5ct
      lxappearance
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
