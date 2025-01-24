pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:3049673142acc7d655127c3751dafaf2e6a4c37d74ed3fdfb45d01fe0140f617";
  hash = "sha256-Rihm4Y8zwx7inhLjJjQxxyCgPIOaS8iA0l8k51fqIHA=";
  finalImageName = imageName;
  finalImageTag = "release";
}
