pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:0236ee02dcbce00b9bd83e0f5fbc51069e7e1161bd59d99885b3ae1734f3392e";
  hash = "sha256-/nCIY2fIr8ydPvDJbxYaGyJ2axlXvXEs+wp0B3RqaCI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
