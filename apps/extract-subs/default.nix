{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-vShyulD7uKHE4Oxz8Xy8HdGJpMbF5kQYlHZlQtIcKIA=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
