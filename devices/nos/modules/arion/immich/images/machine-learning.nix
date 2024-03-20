pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:9a9d289a5fc894dad1aae6e49c09f39735846cda351e9f74879fcb0601437262";
  sha256 = "1q6kk0ldb9fgycx92hnz5yvz4qilhl9g1xsgn9xxhpxhgsqw9d2i";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.99.0";
}
