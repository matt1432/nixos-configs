{
  buildApp,
  ffmpeg_7-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-I7E1LJJwU31LsS3bjhdPjyTw4XhfPp/BOAnIQ3NN/7M=";

  runtimeInputs = [
    ffmpeg_7-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.
  '';
}
