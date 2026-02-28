pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:6d3198165f6385fed7676cbfc6a3e471cd630a702a2f372eeb03b46ac8739e0e";
  hash = "sha256-HiHMraYoYSwTupOdWk33S5GJXNzqiAGnP1aENSB1YTM=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
