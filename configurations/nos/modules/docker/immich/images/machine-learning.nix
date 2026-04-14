pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:a2501141440f10516d329fdfba2c68082e19eb9ba6016c061ac80d23beadf7f3";
  hash = "sha256-fT/SL9PpGoaLlvPaS9E0X22QgWzqilHaipg3FVfXp8o=";
  finalImageName = imageName;
  finalImageTag = "release";
}
