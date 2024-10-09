{
  language = "en";

  intents = {
    PlayAlbum.data = [
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

    PlayArtist.data = [
      {
        sentences = [
          "play[ing] [some] music from [the] [artist] {artist}"
          "play[ing] [the] artist {artist}"
        ];
      }
    ];

    PlayPlaylist.data = [
      {
        sentences = [
          "play[ing] [(the|my)] playlist {playlist}"
        ];
      }
    ];

    PlaySong.data = [
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
  };

  lists = {
    album.wildcard = true;
    artist.wildcard = true;
    playlist.wildcard = true;
    song.wildcard = true;
  };

  responses.intents = {
    PlayAlbum.default = ''
      Searching for the album {{ slots.album }}
      {% if slots.artist != "" %}
        by {{ slots.artist }}
      {% endif %}
      on Spotify and playing it.
    '';

    PlayArtist.default = ''
      Searching for the artist {{ slots.artist }} on Spotify and playing their top songs.
    '';

    PlayPlaylist.default = ''
      Searching for {{ slots.playlist }} in your favorites, or elsewhere if not found, and playing it.
    '';

    PlaySong.default = ''
      Searching for the song {{ slots.song }}
      {% if slots.artist != "" %}
        by {{ slots.artist }}
      {% endif %}
      on Spotify and playing it.
    '';
  };
}
