pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/djerayane/ygege";
  imageDigest = "sha256:9ec0f34aacc9c03b6e325441ef0703deb5ad11fa9233a3f1b74d7af7f868ada8";
  hash = "sha256-eraYVrjWd/C55qgpFpj9zQ8tMgN342zv7KZWABwxPYI=";
  finalImageName = imageName;
  finalImageTag = "docker-publish";
}
