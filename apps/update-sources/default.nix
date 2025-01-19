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
  npmDepsHash = "sha256-k4m8fSF0zOznebbH87p8IPP2SzRR9siVFYBU5Cfs2T0=";

  runtimeInputs = [
    go
    nix-update
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../modules/docker/updateImage.nix {})
  ];
}
