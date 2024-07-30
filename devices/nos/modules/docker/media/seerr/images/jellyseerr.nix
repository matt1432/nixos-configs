pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:788f508bdb33812a77acc8281e1299ff95ddebd07aee40d452e4f0c74bb15dc9";
  sha256 = "1z3ldla4h52ipirmjw8bsfk85pbm3l1hr1i2nl8nyrc37caf8b76";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
