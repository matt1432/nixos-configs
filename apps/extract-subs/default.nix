{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-he0zDkdMmszay/67lCHbCZL56xHRf2ZLMz+TiKocJHk=";

  runtimeInputs = [
    ffmpeg-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.
  '';
}
