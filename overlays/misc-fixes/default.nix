final: prev: {
  # FIXME: missing dep
  spotifywm = prev.spotifywm.overrideAttrs (o: {
    buildInputs = o.buildInputs ++ [final.libxcb];
  });
}
