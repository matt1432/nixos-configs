pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:4504d794123c3f5410cc45bbc61e4d7dbcacec1e1b0cd2e599691430c94e5849";
  hash = "sha256-oK1c6HkVY1Q/29xHtEETGOpwjaBJPq00n6LQ//zUFsM=";
  finalImageName = imageName;
  finalImageTag = "release";
}
