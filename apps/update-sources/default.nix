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
  npmDepsHash = "sha256-TU7HoUGeCXUKwm2s4Np6NQahk6gWBN9WC5vob3zw7Ns=";

  runtimeInputs = [
    go
    nix-update
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../modules/docker/updateImage.nix {})
  ];
}
