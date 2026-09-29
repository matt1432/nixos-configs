pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:1c9dc9b037162d59224a4fc8b1fadd96e343213acf7c828e5d380e28407443fb";
  hash = "sha256-lNaoj5nOKep2iwYh9ZQmMnaK/7VYVUUBiVLfHiBfWuk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
