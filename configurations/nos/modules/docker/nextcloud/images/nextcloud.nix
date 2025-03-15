pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:6854c0336040c628b84bd286fa898675d00d77139b0299c6e39793da454e2115";
  hash = "sha256-1XT0oE6i2Dhpx8PbjdjbSwo0e37KEoSQ+cJNjowECWo=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
