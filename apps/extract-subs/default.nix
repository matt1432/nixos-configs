{
  buildApp,
  ffmpeg_7-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-6eMBq9NJFRWDQ0dnh1wMORXP9fAZeiZ4mj8XPFysA3k=";

  runtimeInputs = [
    ffmpeg_7-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.
  '';
}
