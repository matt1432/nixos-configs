pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:b3d44d324399152be4d50775ff639a364c0fa1cfda67f71b1f38264c4d0ca09f";
  hash = "sha256-KgprQtFpSyQdOC0pzkd/21YGLTEM6qS80Rv/QGbxGWo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
