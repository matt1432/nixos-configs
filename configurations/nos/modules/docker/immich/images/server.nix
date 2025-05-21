pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:4d667c5fd6ffac0395c429fc8a335c607272587643f29fb2ddd9bfe16f1f874e";
  hash = "sha256-CRK4ys6RmBW+JvdJQHoi9YRjf9nVRbwt+xOGoQbfZSM=";
  finalImageName = imageName;
  finalImageTag = "release";
}
