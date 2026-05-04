pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:bed3afb5d46fde809290997760f2e19d41e57d1eb34f507c485d5a8979c7cd8d";
  hash = "sha256-gY4jYz8PichjJ8OsubsMH0TPk+Q/1fu8hfpnkIO9++4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
