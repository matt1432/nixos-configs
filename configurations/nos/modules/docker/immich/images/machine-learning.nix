pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:e157e0fa0d4363b0b6bab1923adab5951bbcdb71cd9016470bc6810dae21d115";
  hash = "sha256-Pvz4YVx4b4A6M8VAD3YSqP6J3gkMkI8RZleoewSSV5k=";
  finalImageName = imageName;
  finalImageTag = "release";
}
