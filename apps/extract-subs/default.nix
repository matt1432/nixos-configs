{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-rDDf8IUW18Pbt0KDZrMoReO0Su1DsQ8eJKAF3NYQXu0=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
