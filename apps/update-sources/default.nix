{
  buildApp,
  curl,
  findutils,
  go,
  jq,
  just,
  nix-update,
  nodejs_latest,
  prefetch-npm-deps,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-k9Rquk7PVP5dMUmiJkLQy4Xsks5ex0/s+kt+iFXTPUE=";

  runtimeInputs = [
    curl
    findutils
    go
    jq
    just
    nix-update
    nodejs_latest
    prefetch-npm-deps

    # We want to use the one from my config with authfile
    # (callPackage ../../modules/docker/updateImage.nix {})
  ];

  meta.description = ''
    Updates all derivation sources in this repository and
    generates a commit message for the changes made.
  '';
}
