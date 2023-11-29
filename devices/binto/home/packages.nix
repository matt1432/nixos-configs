{
  pkgs,
  nixpkgs-wayland,
  ...
}: let
  waypkgs = nixpkgs-wayland.packages.x86_64-linux;
in {
  programs = {
    obs-studio = {
      enable = true;
      plugins = with waypkgs; [
        obs-wlrobs
      ];
    };

    btop.enable = true;
  };
  home.packages =
    (with pkgs; [
      # FIXME: vlc stutters
      mpv
      nextcloud-client
      libreoffice-fresh
      photoqt
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
    ])
    ++ (with pkgs.plasma5Packages; [
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
    ])
    ++ (with pkgs.gnome; [
      gnome-calculator
    ]);

  # TODO: add mic sound
  xdg.configFile."gsr.sh" = {
    executable = true;
    text = ''
      export WINDOW=DP-5
      export CONTAINER=mkv
      export QUALITY=very_high
      export CODEC=auto
      export AUDIO_CODEC=aac
      export FRAMERATE=60
      export REPLAYDURATION=1200
      export OUTPUTDIR=/home/matt/Videos/Replay
      export MAKEFOLDERS=yes
      # export ADDITIONAL_ARGS=

      # Disable compositor in X11 for best performance
      exec /bin/sh -c 'AUDIO="''${AUDIO_DEVICE:-$(pactl get-default-sink).monitor}"; gpu-screen-recorder -v no -w $WINDOW -c $CONTAINER -q $QUALITY -k $CODEC -ac $AUDIO_CODEC -a "$AUDIO" -f $FRAMERATE -r $REPLAYDURATION -o "$OUTPUTDIR" -mf $MAKEFOLDERS $ADDITIONAL_ARGS'
    '';
  };

  xdg.desktopEntries."com.github.iwalton3.jellyfin-media-player" = {
    name = "Jellyfin Media Player";
    comment = "Desktop client for Jellyfin";
    exec = "jellyfinmediaplayer --platform xcb";
    icon = "com.github.iwalton3.jellyfin-media-player";
    terminal = false;
    type = "Application";
    categories = ["AudioVideo" "Video" "Player" "TV"];
    settings = {
      Version = "1.0";
      StartupWMClass = "jellyfin-media-player";
    };
    actions = {
      "DesktopF" = {
        name = "Desktop [Fullscreen]";
        exec = "jellyfinmediaplayer --fullscreen --desktop --platform xcb";
      };
      "DesktopW" = {
        name = "Desktop [Windowed]";
        exec = "jellyfinmediaplayer --windowed --desktop --platform xcb";
      };
      "TVF" = {
        name = "TV [Fullscreen]";
        exec = "jellyfinmediaplayer --fullscreen --tv --platform xcb";
      };
      "TVW" = {
        name = "TV [Windowed]";
        exec = "jellyfinmediaplayer --windowed --tv --platform xcb";
      };
    };
  };
}
