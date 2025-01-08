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
  npmDepsHash = "sha256-nAMu7riJm/6w+ixjzHm4W4YlqOkAwCapM3PHPW2BnnA=";

  runtimeInputs = [
    go
    nix-update
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../modules/docker/updateImage.nix {})
  ];
}
