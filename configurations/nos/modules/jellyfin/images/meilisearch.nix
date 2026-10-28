pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:1f578fa865f8251894b3bf38d6668d6209a3f451f8f65ab953e129d4c1db5ef4";
  hash = "sha256-/ie+/Ce3EiXItVUxE3WOM9jN0Ga7x4mSVyzzopNyRhE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
