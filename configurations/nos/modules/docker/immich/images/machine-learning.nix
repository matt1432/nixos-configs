pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:60dfcf266a9ef3b7376f5678e8c980d4fb61db5fc48c078fe8a326ab1535d60d";
  hash = "sha256-sEOfAs8wAPhez1b/9Yz3k1+jB3Ef8jTmoFsQk7iefe4=";
  finalImageName = imageName;
  finalImageTag = "release";
}
