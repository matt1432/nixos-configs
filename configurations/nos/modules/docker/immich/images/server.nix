pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:14390f3dc9512dc3273b12ccee6363d9be16c388699abc3f3fe0498bb9829937";
  hash = "sha256-9v6bkIB/keC8p4VRXDG1lWFnViNwHqu5wyfntUwSiOE=";
  finalImageName = imageName;
  finalImageTag = "release";
}
