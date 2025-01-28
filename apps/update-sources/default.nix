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
  npmDepsHash = "sha256-FkpmjUu1ctGkDhjrtHV/1Rlbpg8Ht1RsOyMeyh7OWlo=";

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
