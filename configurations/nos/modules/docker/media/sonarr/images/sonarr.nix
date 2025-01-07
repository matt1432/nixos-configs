pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:23f6911b2b81cb69aa03166b53c15081d5c3a5ed58f5b183c5900c2d8fc9759a";
  hash = "sha256-VUDLCXGaVXX/gQC9vsFeAPJmf1b0c/QRVYdSRfEK3FA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
