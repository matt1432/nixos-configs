pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:47ce6f3b2afb17c12b393da2fefb11718f15cd1308baeba1cb61cbbbb9c5aedc";
  hash = "sha256-dbkIpkLnZXVFK2dDhNWqPCGh6byus6AnTre6tj9fn1s=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
