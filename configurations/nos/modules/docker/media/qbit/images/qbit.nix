pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:163f3384db6cba9f68eaa83ca5f4209298b6029ba2d07b5e67562d0715baf5b9";
  hash = "sha256-419igPlZ2cYC8Og2GOnjFD8Y2cxYBLPu0DGuvpBh4E8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
