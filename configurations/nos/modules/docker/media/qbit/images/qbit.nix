pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:2e074403c7b72e6d89cee3d0d41a47f7b5708c6a9e5316f3958c90765cbe12ce";
  hash = "sha256-T3ffScDUN6jOixj2tkEu6qcjv8yDexjzSOO+s9wtJcI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
