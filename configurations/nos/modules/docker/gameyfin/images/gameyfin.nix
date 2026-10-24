pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:c9262445a16bfeedf1e85e6deef028564c94e34727f2fab8619fba149d8bae93";
  hash = "sha256-vL2haDQPqlYSSc5C9ByAoI/SrAYr89rHAAM6Unm/15M=";
  finalImageName = imageName;
  finalImageTag = "2";
}
