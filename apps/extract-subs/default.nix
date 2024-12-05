{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-yrpzsd0w422T/9kErK1gBQm1RjdAA3foOHEUcZXhlzQ=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
