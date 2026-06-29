pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:52f7bf89bb308616c8dfd9cbc7f5b26877309a6a553e0664254a7153dcb9c414";
  hash = "sha256-/+GYEQ2GY6U2RB2seLvzy4WYNOcEJNl1OIaTv5HHB0k=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
