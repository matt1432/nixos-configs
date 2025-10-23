pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:2cb034e217bd09f6ec61972e988d89cb6ed80d5287018d5fd211863c30be9d61";
  hash = "sha256-Epy3O9Na4ne8IMCOvpe+2IUx3N0nYn1Eup3mZWtWIks=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
