pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:c325d7dc17f91a5d0a606eeda10c39c4566ad4bba2d99e9ddaf624ca07ed40b8";
  hash = "sha256-U4TxwFdq990WhhvH6nRwVc5idsKe4zfmk8PLi82bJto=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
