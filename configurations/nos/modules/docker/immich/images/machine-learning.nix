pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:e16c2f166a8174901959fdf85e2e4c7bd1ebc4b37e0b6655de97c41408a260c4";
  hash = "sha256-h57hesZZ7+B9HnV8VCnwBgeDXxRqIZrYDXsJXGQ+FWM=";
  finalImageName = imageName;
  finalImageTag = "release";
}
