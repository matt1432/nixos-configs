pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:b025ebb9219cf8c861bc1094f1c75d812a36c9d247a511214a041679672a7787";
  hash = "sha256-D3MJe4UCHDGxz+yVhuOEcF2BYSWfWuNhxw271bbAqPc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
