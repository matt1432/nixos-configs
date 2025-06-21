pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:df5bbf4e29eff4688063a005708f8b96f13073200b4a7378f7661568459b31e9";
  hash = "sha256-snwU6DEo5uyEOuQjoSf7iH2tiYlH43wuGLEqTfOwTg4=";
  finalImageName = imageName;
  finalImageTag = "release";
}
