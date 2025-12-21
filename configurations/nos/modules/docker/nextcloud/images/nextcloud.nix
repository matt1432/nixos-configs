pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:57f3d877190f234c8ccfc5d9103e6a45a905b27a2d329ff58c5afc8b7ea52d50";
  hash = "sha256-tDUGdruXo68RxM48hEIG4bhGzjkNDltw2iZvq3G8uAQ=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
