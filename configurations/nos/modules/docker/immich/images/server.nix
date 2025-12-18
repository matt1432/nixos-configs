pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:7e2d0df478651551df3358072e68c235200b875eccd6eb4a5c5d8879a7095cf4";
  hash = "sha256-YhI/lBNPtOQe8uugXUYJWAecsl1OSnxWboGT3PcYKmo=";
  finalImageName = imageName;
  finalImageTag = "release";
}
