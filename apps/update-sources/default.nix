{
  buildApp,
  callPackage,
  nodejs_latest,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-XXc5wCGFGtr1e6URp2yXsWEKVrh5GrXQ/+Eud3W8ks4=";

  runtimeInputs = [
    nodejs_latest
    (callPackage ../../nixosModules/docker/updateImage.nix {})
  ];
}
