pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:60e5edcac39172294ad22d55d1b08c2c0a9fe658cad2f2c4d742ae017d7874de";
  hash = "sha256-7dez/8W+jr3ZCrGd16QCkBALtBGYHeAg0Dmkcj+MZl4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
