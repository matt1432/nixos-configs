{ pkgs, ... }:

{
  programs = {

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
      ];
    };

    btop.enable = true;

    jq.enable = true;

    ripgrep = {
      enable = true;
    };

    java = {
      enable = true;
      package = pkgs.temurin-bin-17;
    };
  };

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

  home.packages = with pkgs;
    (with python311Packages; [
      python
      pyclip
      gdown

    ]) ++
    (with nodePackages; [
      undollar

    ]) ++
    (with plasma5Packages; [
      polkit-kde-agent
      qtstyleplugin-kvantum
      ark
      kcharselect
      kdenlive
      okular

      # Dolphin & co
      dolphin
      dolphin-plugins
      kdegraphics-thumbnailers
      ffmpegthumbs
      kio
      kio-admin # needs to be both here and in system pkgs
      kio-extras
      kmime

    ]) ++
    (with gnome; [
      gnome-calculator
      seahorse

    ]) ++ [

    (writeShellScriptBin "Gparted" ''
      (
        sleep 1.5
        while killall -r -0 ksshaskpass > /dev/null 2>&1
        do
          sleep 0.1
          if [[ $(hyprctl activewindow | grep Ksshaskpass) == "" ]]; then
              killall -r ksshaskpass
          fi
        done
      ) &

      exec env SUDO_ASKPASS=${pkgs.plasma5Packages.ksshaskpass}/bin/${pkgs.plasma5Packages.ksshaskpass.pname} sudo -k -EA "${gparted}/bin/${gparted.pname}" "$@"
    '')

    # School
    virt-manager
    gradle
    gradle-completion # not working
    #camunda-modeler

    protonmail-bridge
    thunderbird
    input-emulator
    bc
    spotifywm
    swayosd
    blueberry
    libayatana-appindicator
    libnotify
    libinput
    playerctl
    steam-run
    wineWowPackages.stable
    cabextract
    qt5.qtwayland
    qt6.qtwayland
    bottles-unwrapped
    zscroll
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
    bluez-tools
    vlc
    discord
    brightnessctl
    pulseaudio
    alsa-utils
    wget
    firefox
    tree
    mosh
    rsync
    killall
    hyprpaper
    networkmanagerapplet
    nextcloud-client
    swayidle
    wl-clipboard
    cliphist
    gtklock
    grim
    slurp
    swappy
    fontfor
    qt5ct
    imagemagick
    usbutils
    evtest
    squeekboard
    glib
    appimage-run
  ];
}
