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
  npmDepsHash = "sha256-mUU1yZ30ubDWYRgWwdskGZOTYaA65DFFYPGV3Wbkh1M=";

  runtimeInputs = [
    curl
    findutils
    go
    jq
    nix-update
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../modules/docker/updateImage.nix {})
    (callPackage ../../configurations/homie/modules/home-assistant/netdaemon/update.nix {})
  ];

  meta.description = ''
    Updates all derivation sources in this repository and
    generates a commit message for the changes made.
  '';
}
