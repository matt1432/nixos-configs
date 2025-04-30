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
  npmDepsHash = "sha256-gl299MJ9xcgFMvdMZ80VpR2SZyq/iyASstxPWB/HR/w=";

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
