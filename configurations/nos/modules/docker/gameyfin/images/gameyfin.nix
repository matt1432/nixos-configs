pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:14841180cd91cd1acc12bd6801108f90ff63c75dd56a7d2c36daee04e0f4e39f";
  hash = "sha256-bF9sXHAtys9e4ttfENKxxhb4jvC9PRZaJEsuu8LCoYc=";
  finalImageName = imageName;
  finalImageTag = "2";
}
