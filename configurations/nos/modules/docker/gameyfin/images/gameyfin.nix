pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:857730f1807a92dad1a7bb50e1ba5409e0f27119a2207374045a8f52b4a42cc5";
  hash = "sha256-Py0X+iGpOoXdQWREpVO7w78oOozQffC5iEaxWg4Z2Ys=";
  finalImageName = imageName;
  finalImageTag = "2";
}
