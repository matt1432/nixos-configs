pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:46e91aaad714d2196868dae2719e0bacde27a16e2c3c7a6fc991e68b79146f8c";
  hash = "sha256-AvwiClrOESqHbt4toVT4IxebX0RGi+CT2i6JndYnlsU=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
