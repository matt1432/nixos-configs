pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:1221bc54568a0779227baeaa4282bb0e0db50831b66f9ac9afa9d78513df36ad";
  sha256 = "003xbnmbqr6arv1cx3q64sbsk8galxf5889lqzwjyclwln35mxlp";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "release";
}
