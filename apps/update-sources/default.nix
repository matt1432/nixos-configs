{
  buildApp,
  callPackage,
  curl,
  findutils,
  go,
  jq,
  nix-update,
  nodejs_latest,
  prefetch-npm-deps,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-cR3wqBy3q8pYoCwRi5WUVAIXz9pg4j4U0+OmuDjxsFc=";

  runtimeInputs = [
    curl
    findutils
    go
    jq
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
