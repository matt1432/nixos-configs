pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:79cc1623323d5894922686d8743b4780181428f98eecbfb58ce12c41ef02d1ea";
  hash = "sha256-AijI9V43bdAmRwv6ZL/vYLDa1yRQeGBdaSkpWrjitgI=";
  finalImageName = imageName;
  finalImageTag = "release";
}
