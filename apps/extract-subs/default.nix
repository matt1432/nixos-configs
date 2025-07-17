{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-m0wONLhSHUg+1QzasJvKSlxcGp1ZayJ/C00w1mDzB/4=";

  runtimeInputs = [
    ffmpeg-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.

    FIXME: fluent-ffmpeg is deprecated
  '';
}
