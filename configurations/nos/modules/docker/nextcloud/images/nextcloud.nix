pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:11807bd1c410a62f695dcc7e53aabe8ffaabb3f6bae5f3653676321eb6056dc4";
  hash = "sha256-U4TxwFdq990WhhvH6nRwVc5idsKe4zfmk8PLi82bJto=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
