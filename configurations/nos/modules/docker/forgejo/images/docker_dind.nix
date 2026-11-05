pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:d035bd30886e451b2727ef3cdb9af9a5c537a10d4bc5d18c08d0ffa597e46aeb";
  hash = "sha256-qdZhaR3KPean+XC4l2JK9Ra2ejfbbXJll4eV88w288c=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
