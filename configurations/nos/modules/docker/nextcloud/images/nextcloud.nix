pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:3836464f942e84a31e08bcc2cfe6c61c341902358b4c76c73683f9bd430e2c22";
  hash = "sha256-amiAtP3olTCHoSTIJPvTc1P6RmYBmW4Km+lgPqlwzyI=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
