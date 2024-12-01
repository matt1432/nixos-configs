{
  buildApp,
  callPackage,
  nodejs_latest,
  prefetch-npm-deps,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-orjmkJUATp2ppqHFNtrUg8PBPghYjQodEOI1/hhO3uU=";

  runtimeInputs = [
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../nixosModules/docker/updateImage.nix {})
  ];
}
