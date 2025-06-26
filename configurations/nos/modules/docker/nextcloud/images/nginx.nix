pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:dc53c8f25a10f9109190ed5b59bda2d707a3bde0e45857ce9e1efaa32ff9cbc1";
  hash = "sha256-+cVKXQAOHnitJu/tnV0pFijVunUckpX1veqhyZiXKxU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
