{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-0NNbfyLoBlEFnackX/p4nPIHFzgEem6ucUjKYNJxELs=";

  runtimeInputs = [
    ffmpeg-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.

    FIXME: fluent-ffmpeg is deprecated
  '';
}
