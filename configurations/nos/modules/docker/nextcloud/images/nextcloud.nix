pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:749a9d9a8c5107fd85540a760fa010c7a7e3fe62b8a1e0ee15961bb22b66152c";
  hash = "sha256-7iz9/2slfhcq8QdJxkq+Ui1nXpSzruzW7vPUlzaLqU0=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
