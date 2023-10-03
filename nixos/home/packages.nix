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

  home.packages = with pkgs;
    (with python311Packages; [
      python
      pyclip

    ]) ++
    (with nodePackages; [
      undollar

    ]) ++
    (with plasma5Packages; [
      polkit-kde-agent
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

    # School
    virt-manager
    gradle
    gradle-completion # FIXME: not working
    #camunda-modeler

    # Misc Apps
    thunderbird # TODO: use programs.thunderbird
    firefox # TODO: use programs.firefox
    spotifywm
    zeal
    libreoffice-fresh # TODO: add spelling stuff
    photoqt
    gimp-with-plugins
    vlc
    discord
    nextcloud-client

    # Misc CLI
    neofetch
    qt5.qtwayland
    qt6.qtwayland
    acpi
    progress
    alsa-utils
    wget
    tree
    mosh
    rsync
    killall
    fontfor
    imagemagick
    usbutils

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
}
