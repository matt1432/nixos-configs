pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:8415caab20c3642adb281ea066e82a58b8011b6e12bec5339db66599b700f805";
  hash = "sha256-DYObXDa9J/xH0z4P7e6O+wl1SNK5pM2kytHEYjuEcmA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
