pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:b7464b8799ab31c192d9b51a59d73426fc2deb39db6166a2f5073ae304c1131d";
  hash = "sha256-wERH5f1s2OROZ5opZwt7aO48Ku4rZPzNkajhInO9RkU=";
  finalImageName = imageName;
  finalImageTag = "release";
}
