pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:88858e7f592f82d4f650713c7bed8c0cd792d7f71475a7467c5650a31cd2eda9";
  hash = "sha256-BPP7lsM3Z6yF7iL0dzHQrIQdQo48sIRpnyhuJt2xER0=";
  finalImageName = imageName;
  finalImageTag = "13";
}
