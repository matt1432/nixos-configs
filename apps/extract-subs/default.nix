{
  buildApp,
  ffmpeg_7-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-LKk3KeIqPeETG91DYvaWoXYFWKPO3d5e92wnngGqQeA=";

  runtimeInputs = [
    ffmpeg_7-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.
  '';
}
