{ config, pkgs,  ... }:

{
## Global config to add home-manager module
#############################################################################
  imports =
    [
      <home-manager/nixos>
    ];

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "adm" "mlocate" "video" ];
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  programs.dconf.enable = true;
#############################################################################

  home-manager.users.matt = {

    imports = [
      ./hyprland.nix
    ];

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
      qt5.qtwayland
      qt6.qtwayland
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
      jdk19_headless
      bluez-tools
      spotify
      #spotifywm # fails to build
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
	    if [[ $(hyprctl activewindow | grep Ksshaskpass) == "" ]]; then
	      killall -r ksshaskpass
	    fi
          done
        ) &

        SUDO_ASKPASS = "${pkgs.plasma5Packages.ksshaskpass}/bin/${pkgs.plasma5Packages.ksshaskpass.pname}";
        exec sudo -k -EA '${gparted}/bin/${gparted.pname}' "$@"
      '')
    ];

    xdg.desktopEntries.gparted = {
      name = "GParted";
      genericName = "Partition Editor";
      comment = "Create, reorganize, and delete partitions";
      exec = "Gparted";
      icon = "gparted";
      terminal = false;
      type = "Application";
      categories = [ "GNOME" "System" "Filesystem" ];
      startupNotify = true;
      settings = {
        Keywords = "Partition";
        X-GNOME-FullName = "GParted Partition Editor";
      };
    };

    home.stateVersion = "23.05";
  };
}
