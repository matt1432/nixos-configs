pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:345726c737b63be344843256af77d796d8602771b105302928e1a40fc3bb5589";
  hash = "sha256-UDFarTzGaBiE10zlBCrLt6Jy80hmiqCZvwFj3X9k0Z0=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
