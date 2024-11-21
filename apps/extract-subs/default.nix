{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-0NadIaeU2rU6xGR8eeWpEUZHE5qbuzE99/O1HNtW0ck=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
