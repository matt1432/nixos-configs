pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:42c9d1a2e992d9bb18b540a27eb7708533b51a4af5ff684b9872bfb15eaee737";
  hash = "sha256-H4PBp/vtJvlBv9CSxLNpVsFrbkO9SAmCdeh6tmZiqIg=";
  finalImageName = imageName;
  finalImageTag = "2";
}
