{
  buildApp,
  callPackage,
  go,
  nix-update,
  nodejs_latest,
  prefetch-npm-deps,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-jriJB5WgUtrXG1X4W0Gp/vF2bH4d1ZkU5LUBWJ1o46Y=";

  runtimeInputs = [
    go
    nix-update
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../modules/docker/updateImage.nix {})
  ];
}
