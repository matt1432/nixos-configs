pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:d6850c40261fdc9a4fb33b9521d9d641c4a5dcb82145f7bcc32c9258f81e75a2";
  sha256 = "0zjcx747n54jnnliqd80v8ca43rl09dp3bh6xir5kxq2hw5p22i4";
  finalImageName = "postgres";
  finalImageTag = "14";
}
