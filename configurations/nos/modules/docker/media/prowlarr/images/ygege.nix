pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/uwudev/ygege";
  imageDigest = "sha256:14968534589cfb89906ae1a88bde8cf65925886b2d18530766e1a31a71c82a3c";
  hash = "sha256-PROnSKYQ44PvfKrKYO3K2TKTVec/omwgmSnIfLys++k=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
