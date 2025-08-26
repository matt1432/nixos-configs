pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:c3c5eeafa5549e446b5fd71394399178d9c87da1dec5fd9e9a80a5a0f13e9fad";
  hash = "sha256-A1OGq2GIY5cUN1FCe6r3fuXqZsxjFdD+6+P6pu5aTZA=";
  finalImageName = imageName;
  finalImageTag = "release";
}
