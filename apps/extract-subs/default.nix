{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-vShyulD7uKHE4Oxz8Xy8HdGJpMbF5kQYlHZlQtIcKIA=";

  runtimeInputs = [
    ffmpeg-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.
  '';
}
