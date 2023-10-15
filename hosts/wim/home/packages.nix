{ pkgs, config, nixpkgs-wayland, nix-melt, nurl, ... }: let
  waypkgs = nixpkgs-wayland.packages.x86_64-linux;
in
{
  programs = {

    obs-studio = {
      enable = true;
      plugins = with waypkgs; [
        obs-wlrobs
      ];
    };

    btop.enable = true;
  };

  home.packages = [
    nix-melt.packages.x86_64-linux.default
    nurl.packages.x86_64-linux.default
  ] ++

  (with pkgs.python311Packages; [
    python
    pyclip
  ]) ++

  (with pkgs.nodePackages; [
    undollar
  ]) ++

  (with pkgs.plasma5Packages; [
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

  (with pkgs.gnome; [
    gnome-calculator
    seahorse
  ]) ++

  (with config.nur.repos.rycee; [
    mozilla-addons-to-nix
  ]) ++

  (with pkgs; [
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
    libreoffice-fresh # TODO: add spelling stuff and declarative conf?
    photoqt
    gimp-with-plugins # TODO: set plugins using nix
    vlc
    discord
    nextcloud-client
    jellyfin-media-player
    xournalpp

    # Misc CLI
    neofetch
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
  ]);

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
