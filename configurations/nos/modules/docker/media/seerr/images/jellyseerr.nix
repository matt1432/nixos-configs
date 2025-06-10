pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:8f320036d937d84c385ea5800f87d69ba16ec4d3770fccf6cad803b5e8d66a52";
  hash = "sha256-3kIhchJ1BJXpTa6ahkntIXp1FsUrK7zycVYNRWV9h3w=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
