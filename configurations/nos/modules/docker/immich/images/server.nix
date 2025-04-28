pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:6680d88486251b0264a78a1934fe82eef875555aa6d84d703a0980328a5d5c31";
  hash = "sha256-NGvRah2apg5j3/X7rCdq5DJc0dFB90/JksbmU49Twa8=";
  finalImageName = imageName;
  finalImageTag = "release";
}
