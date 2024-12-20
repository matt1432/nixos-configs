{
  buildApp,
  callPackage,
  nodejs_latest,
  prefetch-npm-deps,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-vIhR/+Pgj35sv/ZX1iL+xWheu6w7vQeJy4OEfa8tXFw=";

  runtimeInputs = [
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../modules/docker/updateImage.nix {})
  ];
}
