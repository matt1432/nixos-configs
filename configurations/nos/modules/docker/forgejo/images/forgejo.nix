pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:7c061fccf20f8e422d886fb4a99aa6f3083fde13c40d78ddac67a83e0d4349f4";
  hash = "sha256-siywr+j1M/mHPVBm4UanM0/umnQviXP65LD21GK62O8=";
  finalImageName = imageName;
  finalImageTag = "11";
}
