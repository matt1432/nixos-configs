{ config, ... }:

{
  imports =
    [
      <home-manager/nixos>
    ];

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "adm" "mlocate" "video" ];
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  };

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
        xcursorthemes

      ]) ++
      (with python311Packages; [
        python
        pyclip

      ]) ++
      (with plasma5Packages; [
        polkit-kde-agent
        qtstyleplugin-kvantum
        breeze-icons
        dolphin
        dolphin-plugins
        ffmpegthumbs
        kio-admin # needs to be both here and in system pkgs
        ark
        kcharselect
        #kdenlive
        kmime
        okular

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
      wl-color-picker # add bind for this in hyprland
      xclip
      xdg-utils
      pavucontrol # TODO: open on left click
      gimp-with-plugins
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
      mosh
      rsync
      killall
      jq # enable using home-manager?
      ripgrep-all
      hyprpaper
      rofi-wayland
      networkmanagerapplet
      nextcloud-client
      tutanota-desktop
      galaxy-buds-client
      swaynotificationcenter
      swayidle
      wl-clipboard
      cliphist
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
      gparted # doesn't open without sudo
      (writeShellScriptBin "Gparted" ''
        (
          sleep 0.5
          while killall -r -0 ksshaskpass > /dev/null 2>&1
          do
	    sleep 0.1
	    if [[ $(hyprctl activewindow | grep Ksshaskpas) == "" ]]; then
	      killall -r ksshaskpass
	    fi
          done
        ) &

        exec sudo -k -EA '${gparted}/bin/${gparted.pname}' "$@"
      '')
    ];

    home.sessionVariables = {
      XDG_DATA_DIRS = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:\$XDG_DATA_DIRS";
      SUDO_ASKPASS= "${pkgs.plasma5Packages.ksshaskpass}/bin/${pkgs.plasma5Packages.ksshaskpass.pname}";
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
        exec-once = ${pkgs.plasma5Packages.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
        source = ~/.config/hypr/main.conf
        env = XDG_DATA_DIRS, ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS
        env = SUDO_ASKPASS, ${pkgs.plasma5Packages.ksshaskpass}/bin/${pkgs.plasma5Packages.ksshaskpass.pname}

      '';
    };

    home.stateVersion = "23.05";
  };
}
