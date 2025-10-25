pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:23c0bc5f0e94f828167c26d6f63066e0a0d2778c4e8e14e5a2013325678f199e";
  hash = "sha256-UDFarTzGaBiE10zlBCrLt6Jy80hmiqCZvwFj3X9k0Z0=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
