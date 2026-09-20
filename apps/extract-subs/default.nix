{
  buildApp,
  ffmpeg_7-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-patYgnzqN9Q5W9kUmYLZ1CNX8bB2ohCWMBip5qJzMNM=";

  runtimeInputs = [
    ffmpeg_7-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.
  '';
}
