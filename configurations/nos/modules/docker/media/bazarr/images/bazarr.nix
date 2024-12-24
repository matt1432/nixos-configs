pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:4e6e74dd25e0b7a0dd20190b1a9e0ec1adb74b56d7b87ce5c9d073f44b2cf2b1";
  hash = "sha256-GuiqgMiDMqxCUxSPT7mF2NHNUMpHCMLztqUjhjwowCk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
