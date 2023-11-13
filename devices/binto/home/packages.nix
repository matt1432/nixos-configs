{ ... }: {
  # Disable compositor in X11 for best performance
  # TODO: add mic sound
  xdg.configFile."gpu-screen-recorder.env".text = ''
    WINDOW=focused
    CONTAINER=mp4
    QUALITY=very_high
    CODEC=auto
    AUDIO_CODEC=opus
    FRAMERATE=60
    REPLAYDURATION=1200
    OUTPUTDIR=/home/matt/Videos/Replay
    MAKEFOLDERS=yes
    ADDITIONAL_ARGS="-s 2560x1440"
  '';

  xdg.desktopEntries."com.github.iwalton3.jellyfin-media-player" = {
    name = "Jellyfin Media Player";
    comment = "Desktop client for Jellyfin";
    exec = "jellyfinmediaplayer --platform xcb";
    icon = "com.github.iwalton3.jellyfin-media-player";
    terminal = false;
    type = "Application";
    categories = [ "AudioVideo" "Video" "Player" "TV" ];
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
