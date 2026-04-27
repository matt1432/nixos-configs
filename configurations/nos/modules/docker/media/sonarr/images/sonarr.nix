pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:3580aec3802c915f0f819a88d5099abce61734b925732b8393d176b5dc561020";
  hash = "sha256-Qsdq9WqpwE+X2ZclsK0b8iL6Yz95C5bXl38ErtkUh3g=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
