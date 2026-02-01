pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:8ac5a6d471fbb6fcfec6bc34854dd5a947c1795547f0d9345d9bf1803d1209e3";
  hash = "sha256-8WgHNLCh5q1/1LFDnd9UQP8g2Hh35/mqFywfyRXMmvw=";
  finalImageName = imageName;
  finalImageTag = "release";
}
