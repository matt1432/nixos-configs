pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:c15bff75068effb03f4355997d03dc7e0fc58720c2b54ad6f7f10d1bc57efaa5";
  hash = "sha256-nvscljSiCxbP0Vv2kEKxTSGbxmjFIuQeOsjKAWWSO3Q=";
  finalImageName = imageName;
  finalImageTag = "release";
}
