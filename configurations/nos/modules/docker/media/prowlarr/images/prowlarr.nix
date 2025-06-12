pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:b058be8a4e083e0cba238f03759994617a559abe0c89e5ed66454b44395da6a9";
  hash = "sha256-63DWgzhUYfxxkqEV/Xv2yadM8FZrGTjU8cq6IZB7nhA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
