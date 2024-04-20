pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:28284d06a5259e81df0f243570d7acad04589ed0cd33f9c1e4f5808ab8864c33";
  sha256 = "0fh2mn1g6q4w4ny4igj6yx3xlzfgvq35j7yvvz84cdkkcjs164k7";
  finalImageName = "postgres";
  finalImageTag = "14";
}
