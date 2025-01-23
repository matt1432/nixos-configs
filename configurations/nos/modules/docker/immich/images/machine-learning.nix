pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:c0740b545ac84ca6cd73265f6beca2c65317b383dc7e4d89dc1d1daf63d895f6";
  hash = "sha256-SRiD9AYgWG9DhPb4ntVZlaN8uM2o69lijKJpQNo7NG4=";
  finalImageName = imageName;
  finalImageTag = "release";
}
