pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "alexfozor/flaresolverr";
  imageDigest = "sha256:3e5e1335c31365b5b0d9a737097c6a719de0ba49fed7db65cd828d75ae1bbecb";
  hash = "sha256-8FuBXLmqM/B/uuH/PJuKQIWhHnozSJ2RR0VI7m+rVDw=";
  finalImageName = imageName;
  finalImageTag = "pr-1300-experimental";
}
