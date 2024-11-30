{
  buildApp,
  callPackage,
  nodejs_latest,
  prefetch-npm-deps,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-XXc5wCGFGtr1e6URp2yXsWEKVrh5GrXQ/+Eud3W8ks4=";

  runtimeInputs = [
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../nixosModules/docker/updateImage.nix {})
  ];
}
