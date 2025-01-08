{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-VPvEbpLIuPx7Oax5UNEIf8/Gd34UMZkuQGt4bCnUwQQ=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
