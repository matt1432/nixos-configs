{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-6msnT1ue5FIx0RzRC4ENABPq/1GOCftOEC9dZ0fqPqA=";

  runtimeInputs = [
    ffmpeg-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.
  '';
}
