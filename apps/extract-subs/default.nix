{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-xhnq5lHge1Ga3q020UCC8gSgQ0qNXSnqumXzGBjXnQA=";

  runtimeInputs = [
    ffmpeg-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.
  '';
}
