pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:9855f6a0a998db508ca97894997b17f3a0a61e9388b204d861110c19c42814eb";
  hash = "sha256-oGGS9e3Lz5owY0Sj6axay3DcCzsdyRlY6aOjAFeTB70=";
  finalImageName = imageName;
  finalImageTag = "release";
}
