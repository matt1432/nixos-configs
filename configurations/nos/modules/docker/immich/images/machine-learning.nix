pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:14367bfb374b8576ddf49abd67c5ca0190a4c7fcf6303cdad65d7f7bf1a50bc2";
  hash = "sha256-HJOPZI3CwSWNoYIKzjb3f8Yv5AJRSz+VwmgBTMFigRU=";
  finalImageName = imageName;
  finalImageTag = "release";
}
