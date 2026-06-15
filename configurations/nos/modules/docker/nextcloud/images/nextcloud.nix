pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:b1b0e0a10b2f50c546e14b2c6f700a9435ca1282583150fdd6d01be99666ab7d";
  hash = "sha256-KuA4ZZh68YbQcPr4mrHk87eu/aZVCsrEYsZWpQ5J9QM=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
