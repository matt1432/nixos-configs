pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:90e5fe0d0bd83fea01120870bf6e01507097c706e1583fad1d56ef0cc6c41af8";
  hash = "sha256-3T8qo2et2Yq7yGIbmXG4G9yCPYJk0PU/ySFb/nPfTbU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
