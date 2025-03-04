{
  config,
  pkgs,
  ...
}: {
  services.home-assistant = {
    customComponents = builtins.attrValues {
      inherit
        (pkgs.scopedPackages.hass-components)
        spotifyplus
        ;
    };

    extraComponents = [
      "spotify"
    ];

    customSentences."assist_spotify" = import ./sentences.nix;

    configFiles.
      ".storage/SpotifyWebApiPython_librespot_credentials.json"
      .source = config.sops.secrets.spotifyd.path;

    config.intent_script = {
      PlayAlbum = {
        async_action = false;
        action = [
          {
            service = "netdaemon.spotify_play_album";
            data = {
              artist = "{{ artist }}";
              album = "{{ album }}";
            };
          }
        ];
      };

      PlayArtist = {
        async_action = false;
        action = [
          {
            service = "netdaemon.spotify_play_artist";
            data.artist = "{{ artist }}";
          }
        ];
      };

      PlayPlaylist = {
        async_action = false;
        action = [
          {
            service = "netdaemon.spotify_play_playlist";
            data.playlist = "{{ playlist }}";
          }
        ];
      };

      PlaySong = {
        async_action = false;
        action = [
          {
            service = "netdaemon.spotify_play_song";
            data = {
              artist = "{{ artist }}";
              song = "{{ song }}";
            };
          }
        ];
      };

      Pause = {
        async_action = false;
        action = [
          {
            service = "netdaemon.spotify_pause_unpause";
            data.pause = true;
          }
        ];
      };

      Unpause = {
        async_action = false;
        action = [
          {
            service = "netdaemon.spotify_pause_unpause";
            data.pause = false;
          }
        ];
      };
    };
  };
}
