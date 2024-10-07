{
  language = "en";

  intents = {
    PlayArtist.data = [
      {
        sentences = [
          "play [some] music from [artist] {artist}"
        ];
      }
    ];
  };

  lists = {
    artist.wildcard = true;
  };

  responses.intents = {
    PlayArtist.default = ''
      Searching for {{ slots.artist }} on Spotify and playing their top songs.
    '';
  };
}
