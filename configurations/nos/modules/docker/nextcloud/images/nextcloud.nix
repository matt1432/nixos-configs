pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:043ad29d7423bc750c3bff8210413d8ca591f971c98680ee1edd1367b950cc49";
  hash = "sha256-KuA4ZZh68YbQcPr4mrHk87eu/aZVCsrEYsZWpQ5J9QM=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
