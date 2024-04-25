pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:c7b1085b1a26835716593174ee2169e76e8ee1d37cc8aab0b78a3e4da794d8cb";
  sha256 = "0zjcx747n54jnnliqd80v8ca43rl09dp3bh6xir5kxq2hw5p22i4";
  finalImageName = "postgres";
  finalImageTag = "14";
}
