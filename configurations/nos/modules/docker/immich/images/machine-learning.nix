pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:e25a410b99567c369da14508c7e874dfbeee1bcf06adda2c4148ab2f32f9463d";
  hash = "sha256-Fkm4DzAaRJdJr1v8QLPARn1jUJw1oSW8t1ioQeiDwj4=";
  finalImageName = imageName;
  finalImageTag = "release";
}
