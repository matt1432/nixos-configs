{
  language = "en";

  lists = {
    album.wildcard = true;
    artist.wildcard = true;
    playlist.wildcard = true;
    song.wildcard = true;
  };

  # ---------------------------------------
  # PlayAlbum
  # ---------------------------------------
  intents.PlayAlbum.data = [
    {
      sentences = [
        "play[ing] [the] album {album} from [the] [artist] {artist}"
      ];
    }
    {
      sentences = [
        "play[ing] [the] album {album}"
      ];
      slots.artist = "";
    }
  ];

  responses.intents.PlayAlbum.default = ''
    Searching for the album {{ slots.album }}
    {% if slots.artist != "" %}
      by {{ slots.artist }}
    {% endif %}
    on Spotify and playing it.
  '';

  # ---------------------------------------
  # PlayArtist
  # ---------------------------------------
  intents.PlayArtist.data = [
    {
      sentences = [
        "play[ing] [some] music from [the] [artist] {artist}"
        "play[ing] [the] artist {artist}"
      ];
    }
  ];

  responses.intents.PlayArtist.default = ''
    Searching for the artist {{ slots.artist }} on Spotify and playing their top songs.
  '';

  # ---------------------------------------
  # PlayPlaylist
  # ---------------------------------------
  intents.PlayPlaylist.data = [
    {
      sentences = [
        "play[ing] [(the|my)] playlist {playlist}"
      ];
    }
  ];

  responses.intents.PlayPlaylist.default = ''
    Searching for {{ slots.playlist }} in your favorites, or elsewhere if not found, and playing it.
  '';

  # ---------------------------------------
  # PlaySong
  # ---------------------------------------
  intents.PlaySong.data = [
    {
      sentences = [
        "play[ing] [the] (song|track) {song} from [the] [artist] {artist}"
      ];
    }
    {
      sentences = [
        "play[ing] [the] (song|track) {song}"
      ];
      slots.artist = "";
    }
  ];

  responses.intents.PlaySong.default = ''
    Searching for the song {{ slots.song }}
    {% if slots.artist != "" %}
      by {{ slots.artist }}
    {% endif %}
    on Spotify and playing it.
  '';

  # ---------------------------------------
  # Pause
  # ---------------------------------------
  intents.Pause.data = [
    {
      sentences = [
        "(pause|stop) [the] [(song|track|music)]"
        "(pause|stop) spotify"
      ];
    }
  ];

  responses.intents.Pause.default = ''
    Pausing the music.
  '';

  # ---------------------------------------
  # Unpause
  # ---------------------------------------
  intents.Unpause.data = [
    {
      sentences = [
        "(unpause|resume) [the] [(song|track|music)]"
        "(unpause|resume) spotify"
      ];
    }
  ];

  responses.intents.Unpause.default = ''
    Resuming the music.
  '';
}
