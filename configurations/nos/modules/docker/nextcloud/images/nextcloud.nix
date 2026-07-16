pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:8a62df1f3bd0f470dda9810eb5ee06d45c9bf4e0fdab4d501b12735a3331204c";
  hash = "sha256-amiAtP3olTCHoSTIJPvTc1P6RmYBmW4Km+lgPqlwzyI=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
