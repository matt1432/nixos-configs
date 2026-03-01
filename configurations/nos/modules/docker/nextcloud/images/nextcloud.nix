pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:addc5346b8c87e20538f49f0e3d22769f72f3d25d2a8b14c48ed8bac5b6fa625";
  hash = "sha256-HiHMraYoYSwTupOdWk33S5GJXNzqiAGnP1aENSB1YTM=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
