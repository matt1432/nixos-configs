{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-zxmhci+JnHZH0A1tnWrwP20qj4tUFq1tL9X3GJzx/bQ=";

  runtimeInputs = [
    ffmpeg-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.
  '';
}
