{
  buildApp,
  callPackage,
  nodejs_latest,
  prefetch-npm-deps,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-wnhPCujOtksqvwsAFwka7/VdH+RgMXheL7W9uhO8zGk=";

  runtimeInputs = [
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../modules/docker/updateImage.nix {})
  ];
}
