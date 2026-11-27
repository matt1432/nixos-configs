pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:6a51db59870df7ce1b6efbd56a93008e580334591edeac3cf4a55754a8dc2407";
  hash = "sha256-sp9Qtr6Hxigq87fc1X8g2uVk2uPVTGUgM6lQDTVtcdc=";
  finalImageName = imageName;
  finalImageTag = "2";
}
