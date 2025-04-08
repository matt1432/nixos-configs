pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:e904d95a06623eea6489507642275684f1a559b54093356596261b8d0289c53e";
  hash = "sha256-NJSsKlazRjYhV6lUzs28DwunGUZHZbkzaNe1BS3ifmg=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
