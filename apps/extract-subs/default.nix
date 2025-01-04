{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Ze7WxJ4WVso3Bn+jEDstLhGPjI29kKoJrdeZFiW6jZ0=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
