pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:bb50bac26881613af15deb4df891e4a7cb09e3333aec20a0522cb188fb22b11d";
  hash = "sha256-uTvSY7i9hzeLjZY+XBULIoSG4bEt2Yvt4BgxpyR+wls=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
