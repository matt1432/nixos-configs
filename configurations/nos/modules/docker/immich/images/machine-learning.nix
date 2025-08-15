pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:25fca00128f10444303c93829516927bd14804ccbe9b7450eb41c64c722c5ac4";
  hash = "sha256-1pILK+Dq0C3d5Ln+nJpqhFd+2SrYhe4heDY0fDtwkJU=";
  finalImageName = imageName;
  finalImageTag = "release";
}
