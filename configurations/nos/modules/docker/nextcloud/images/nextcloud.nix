pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:1654f68700a482a13feca52c3235b949d8771624d738c17e9c82e437fe5de5ec";
  hash = "sha256-xYqfCZAOBERPerr2Nd0c5dyh6q9UdyGGFtHwMIVVGMY=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
