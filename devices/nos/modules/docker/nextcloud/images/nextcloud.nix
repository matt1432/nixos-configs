pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:e452bb5fc952269c50196a9f914fb84d37f3bb8ef4ff96ad3b5080f990bed5c9";
  sha256 = "0y7xxirrvn2zxpl1sdnxh3xl3jn6xz696f6lrm71yfgpd5vyb9k4";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
