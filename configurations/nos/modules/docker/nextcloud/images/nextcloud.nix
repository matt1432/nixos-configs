pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:9396168631181e71e6ed62c3369845d7fb4aef0ee03e10e6bfbbae056c13ad60";
  hash = "sha256-tDUGdruXo68RxM48hEIG4bhGzjkNDltw2iZvq3G8uAQ=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
