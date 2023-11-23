{
  pkgs,
  hyprland,
  ...
}: {
  programs.dconf.enable = true;

  services = {
    xserver = {
      displayManager = {
        sessionPackages = [
          hyprland.packages.x86_64-linux.default
        ];
      };

      libinput.enable = true;
    };

    greetd = {
      settings = {
        initial_session = {
          command = "${hyprland.packages.x86_64-linux.default}/bin/Hyprland";
          user = "matt";
        };
      };
    };

    dbus.enable = true;
    gvfs.enable = true;
    flatpak.enable = true;
  };

  programs.kdeconnect.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    p7zip # for reshade
    xclip
    wl-clipboard

    # FIXME: vlc stutters
    mpv
    flat-remix-icon-theme
    nextcloud-client
    libreoffice-qt
    hunspell
    hunspellDicts.en_CA
    jellyfin-media-player
    spotifywm
    thunderbird
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
}
