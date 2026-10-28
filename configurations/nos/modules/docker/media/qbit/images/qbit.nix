pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:75ecbb1c89ab7b0a21c4bde40b4820e4f1649d2d56d83b91913422155e8d2a5f";
  hash = "sha256-NDfyedwgW2MJQ0Gz9JDoCUGAIv4LOtotgdDuvVD0Mr0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
