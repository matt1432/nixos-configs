{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-rEx1HU+q8UIA7jN/3bIYODXJcjtvanskpOOKNmMSWVs=";

  runtimeInputs = [
    ffmpeg-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.

    FIXME: fluent-ffmpeg is deprecated
  '';
}
