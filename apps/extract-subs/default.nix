{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-nhjPsntOSBL8l9/G8xJ/5kA4dGtdFM9+oMxJgULO5Pc=";

  runtimeInputs = [
    ffmpeg-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.

    FIXME: fluent-ffmpeg is deprecated
  '';
}
