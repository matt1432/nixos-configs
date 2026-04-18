pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:1fc78c81850d658f17701bfa9d8de58ccc12ff27d36a9a176c6299e55aaf4b4e";
  hash = "sha256-I401El5PRM2F13cM46rqQDfd+xvWJlKsrx3MyEBHFog=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
