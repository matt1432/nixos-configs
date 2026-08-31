pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:d9d418cd89ea49c7b4705110398fe2957192d946302fe0645786cae3b5ce0aba";
  hash = "sha256-WT6C7i8sOiGrgzONf/iwhwymOie1TYcghNSepPgZAls=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
