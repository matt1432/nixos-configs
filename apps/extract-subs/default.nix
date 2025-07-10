{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-MJrvvxGG1wtACECa6Mf7nnSHhj6SGo7qyEPrFKc2bmI=";

  runtimeInputs = [
    ffmpeg-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.

    FIXME: fluent-ffmpeg is deprecated
  '';
}
