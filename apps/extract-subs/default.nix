{
  buildApp,
  ffmpeg_7-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-wo+jRUJAiz6DWaCbHKGH9PD+FNKNy1vZ4gblAlk385Y=";

  runtimeInputs = [
    ffmpeg_7-full
  ];

  meta.description = ''
    Extract all `srt` subtitle files from a `mkv` video with the appropriate name.
  '';
}
