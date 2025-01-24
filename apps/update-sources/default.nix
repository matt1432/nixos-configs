{
  buildApp,
  callPackage,
  findutils,
  go,
  nix-update,
  nodejs_latest,
  prefetch-npm-deps,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-AxCCZQfsvl148hqmf/gz7c3imkQsfhuwoxZMF6g7dgg=";

  runtimeInputs = [
    findutils
    go
    nix-update
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../modules/docker/updateImage.nix {})
  ];

  meta.description = ''
    Updates all derivation sources in this repository and
    generates a commit message for the changes made.
  '';
}
