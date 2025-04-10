pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:45472bf7b3bc012f5a20a5ea2cc88636c6d6728ec4fed1b880b7198f36cf23f6";
  hash = "sha256-NJSsKlazRjYhV6lUzs28DwunGUZHZbkzaNe1BS3ifmg=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
