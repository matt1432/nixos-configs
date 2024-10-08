{
  language = "en";

  intents = {
    PlayArtist.data = [
      {
        sentences = [
          "play[ing] [some] music from [the] [artist] {artist}"
          "play[ing] [the] artist {artist}"
        ];
      }
    ];

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
  };

  lists = {
    artist.wildcard = true;
    album.wildcard = true;
  };

  responses.intents = {
    PlayArtist.default = ''
      Searching for {{ slots.artist }} on Spotify and playing their top songs.
    '';

    PlayAlbum.default = ''
      Searching for the album {{ slots.album }}
      {% if slots.artist != "" %}
        by {{ slots.artist }}
      {% endif %}
      on Spotify and playing it.
    '';
  };
}
