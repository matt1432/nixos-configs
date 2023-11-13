{ pkgs, lib, ... }: {
  programs.dconf.enable = true;

  services = {
    xserver = {
      enable = true;

      # Enable the KDE Plasma Desktop Environment.
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };
    dbus.enable = true;
    gvfs.enable = true;
    flatpak.enable = true;
  };

  environment.systemPackages = with pkgs; [
    p7zip # for reshade
    xclip
    wl-clipboard
    vlc
    flat-remix-icon-theme
    nextcloud-client
    libreoffice-qt
    hunspell
    hunspellDicts.en_CA
    jellyfin-media-player
    spotifywm
    prismlauncher-qt5
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    })

    # School
    virt-manager
    bluej
    xournalpp
  ];

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    oxygen
    khelpcenter
    konsole
    plasma-browser-integration
  ];
}
