pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:2f2817898bfd6ca32372a8e56ee41523ffbb5b9690be67907926530b2d6dbd1e";
  sha256 = "1jbv0dcnxc1fzppqb8ks6wfvbm4l2ngp9bc3w9zq74jyfy7agykg";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.103.0";
}
