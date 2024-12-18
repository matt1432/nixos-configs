{
  buildApp,
  callPackage,
  nodejs_latest,
  prefetch-npm-deps,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-ROB8aqyiwVJJzTEIf8oxuD1n6yhJCGb46i9aDmA7b8Y=";

  runtimeInputs = [
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../modules/docker/updateImage.nix {})
  ];
}
