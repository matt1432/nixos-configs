pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:4e2f17bf9a368201e8641af1d73722cddf7a71da9afc3c14e4e9d144e3c57f67";
  hash = "sha256-QV6iB/eBWHhAbTbEbVT18yWjn5P01xc2E9bWrtsH224=";
  finalImageName = imageName;
  finalImageTag = "release";
}
