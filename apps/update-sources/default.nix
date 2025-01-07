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
  npmDepsHash = "sha256-Y4qFOepOdKihQPyEx/E5+ySCbsFeDOLM9h+angwJR4Y=";

  runtimeInputs = [
    go
    nix-update
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../modules/docker/updateImage.nix {})
  ];
}
