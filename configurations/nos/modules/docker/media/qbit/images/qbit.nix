pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:eeea9f8a8cdde23555186843d26e8ded1222421f31f98a5cc1b50c2882ebcf4e";
  hash = "sha256-Xum/LtKX26XXgB0UNG4cJmvXwX6Q2zvj3o5XA1PFBCA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
