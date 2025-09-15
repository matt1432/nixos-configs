pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:29f12a20fd1975c9df06d99a65658cec40bf2357fb597499c32ee50a75f250ea";
  hash = "sha256-p01OGSrx4ZuUiM5c45+WsLdnO5+YU/ApqpKDyYsodUU=";
  finalImageName = imageName;
  finalImageTag = "release";
}
