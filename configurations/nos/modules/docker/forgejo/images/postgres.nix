pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:473783dca8870bbde3a32370c72a9de9406f37d048c05d7b5c40f93e7c23d827";
  hash = "sha256-nueGvbKaQF4xqrK+Z1+nNOmWQg4u8aPrF+1Zw/njaP8=";
  finalImageName = imageName;
  finalImageTag = "14";
}
