pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:cafc1ff51b95a931d17d69226435bbb28ea314f151598b8b087391c232d00ab6";
  hash = "sha256-cgVUM0/3G39Z1+9YP0ND7djEZy+VZn8TLrdyOBsrI98=";
  finalImageName = imageName;
  finalImageTag = "release";
}
