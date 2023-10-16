final: prev: {
  spotifywm = prev.spotifywm.overrideAttrs (oldAttrs: rec {
    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,lib,share}
      install -Dm644 spotifywm.so $out/lib/
      ln -sf ${prev.spotify}/bin/spotify $out/bin/spotify
      ln -sf ${prev.spotify}/share/applications/ $out/share/applications
      ln -sf ${prev.spotify}/share/icons $out/share/icons

      # wrap spotify to use spotifywm.so
      wrapProgram $out/bin/spotify --set LD_PRELOAD "$out/lib/spotifywm.so"
      # backwards compatibility for people who are using the "spotifywm" binary
      ln -sf $out/bin/spotify $out/bin/spotifywm

      runHook postInstall
    '';
  });
}

