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
  npmDepsHash = "sha256-z5Fa9PiMaGZ1EgO2BpV3e9oc78NsNkmWW34PgiivbwM=";

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
