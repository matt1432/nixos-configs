pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:7d7b4a2a90c56372400a912d8616322f658a99cd5104eaf7b77e0ac881a8921b";
  hash = "sha256-UDFarTzGaBiE10zlBCrLt6Jy80hmiqCZvwFj3X9k0Z0=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
