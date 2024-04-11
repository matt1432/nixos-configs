pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:85454da67edd92e05be6c772b081525fc35730051c3d04b806fe73ea78b7c680";
  sha256 = "0fh2mn1g6q4w4ny4igj6yx3xlzfgvq35j7yvvz84cdkkcjs164k7";
  finalImageName = "postgres";
  finalImageTag = "14";
}
