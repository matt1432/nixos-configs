pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:5e915ab0bdf0aed036f2bce05abcfa85e4fb748df982cdbca1e600a77e02ab24";
  sha256 = "1snyqdwyg51icbryrzbd0xaq40j4qmdzikxyw2s64lq9q5vmf6xy";
  finalImageName = imageName;
  finalImageTag = "latest";
}
