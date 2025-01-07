{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-j9nFdIPnN1nlBkWK0yYyShRTaAo2z0hiE+5nSMnWWYM=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
