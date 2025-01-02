{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Ke1os0/XJi2eRJSqEoEYsfWNtgcTO87Onem8bpBQ0/M=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
