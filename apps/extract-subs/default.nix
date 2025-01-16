{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-7UhA8oj+AES+YUrbNJZHQ5SdkzSpcjh7YP8f2WiA3qc=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
