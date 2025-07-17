{
  buildApp,
  callPackage,
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
  npmDepsHash = "sha256-EDATYF1/ytDNuxo93uzYo66PPFvAvHFJKlbL4LQXs8U=";

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
    (callPackage ../../configurations/homie/modules/home-assistant/netdaemon/update.nix {})
  ];

  meta.description = ''
    Updates all derivation sources in this repository and
    generates a commit message for the changes made.
  '';
}
