pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:8adebf414256f6e4f837bfbb66fa94f14f4da7260e3a1d65cbba49e4e35d8764";
  hash = "sha256-EOO48lhgMpWeWs35x3K5KqeyVRgvlYaBsvMSWBN1bRs=";
  finalImageName = imageName;
  finalImageTag = "release";
}
