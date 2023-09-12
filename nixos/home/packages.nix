{ pkgs, ... }:

{
  programs = {

    btop.enable = true;

    jq.enable = true;

    ripgrep = {
      enable = true;
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
      dolphin
      dolphin-plugins
      kdegraphics-thumbnailers
      ffmpegthumbs
      kio
      kio-admin # needs to be both here and in system pkgs
      kio-extras
      ark
      kcharselect
      kdenlive
      kmime
      okular

    ]) ++
    (with gnome; [
      gnome-calculator
      seahorse
      adwaita-icon-theme

    ]) ++
  [
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
    virtmanager
    #camunda-modeler
    #
    protonmail-bridge
    thunderbird
    input-emulator
    bc
    spot
    swayosd
    blueberry
    libayatana-appindicator
    libnotify
    libinput
    playerctl
    dracula-theme
    dracula-icon-theme
    steam-run
    wineWowPackages.stable
    cabextract
    qt5.qtwayland
    qt6.qtwayland
    bottles-unwrapped
    zscroll
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
    gtklock-playerctl-module
    gtklock-powerbar-module
    grim
    slurp
    swappy
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
  ];
}
