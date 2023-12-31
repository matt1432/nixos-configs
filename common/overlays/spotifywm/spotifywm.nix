# https://github.com/NixOS/nixpkgs/blob/77b27fdb6a9ba01f60b8f5c48038938cf14b7d2f/pkgs/applications/audio/spotifywm/default.nix
{
  lib,
  stdenv,
  spotifywm-src,
  libX11,
  makeBinaryWrapper,
  spotify,
  symlinkJoin,
  ...
}: let
  spotifywm = stdenv.mkDerivation {
    pname = "spotifywm";
    version = spotifywm-src.rev;

    src = spotifywm-src;

    buildInputs = [libX11];

    installPhase = ''
      runHook preInstall

      install -Dm644 spotifywm.so $out/lib/spotifywm.so

      runHook postInstall
    '';
  };
in
  symlinkJoin {
    inherit (spotifywm) name;

    nativeBuildInputs = [makeBinaryWrapper];

    paths = [
      spotify
      spotifywm
    ];

    postBuild = ''
      wrapProgram $out/bin/spotify \
        --suffix LD_PRELOAD : "$out/lib/spotifywm.so"

      ln -sf $out/bin/spotify $out/bin/spotifywm
    '';

    meta = {
      homepage = "https://github.com/dasJ/spotifywm";
      description = "Wrapper around Spotify that correctly sets class name before opening the window";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [jqueiroz the-argus];
      mainProgram = "spotify";
    };
  }
