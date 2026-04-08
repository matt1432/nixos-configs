pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:6a2952539e2a9c8adcf6fb74850bb1ba7e1db2804050acea21baafdc9154c430";
  hash = "sha256-ZViT25KF+EuzWw6uSJguKPy8R/udksyDFKfp72MPfvM=";
  finalImageName = imageName;
  finalImageTag = "release";
}
