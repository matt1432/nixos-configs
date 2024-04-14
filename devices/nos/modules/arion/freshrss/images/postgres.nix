pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:369f1bdcc22fa90fc0fc38f0b462aede1812b604f957d14227a84ffc89d85df5";
  sha256 = "0fh2mn1g6q4w4ny4igj6yx3xlzfgvq35j7yvvz84cdkkcjs164k7";
  finalImageName = "postgres";
  finalImageTag = "14";
}
