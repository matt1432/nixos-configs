pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:4dc544396bf08cd92066f83a270155201d80512add127ca9fac2d3e56694d2a4";
  sha256 = "17hp5ljnc34nmj74wjvvicc3zjkwhrq4k748r5jbmydgb4bsvji7";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.108.0";
}
