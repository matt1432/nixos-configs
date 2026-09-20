pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:457e4eec2ee3f5e4ef59f237ad51f6143deba9f7445ab48bb5204a98888ef9aa";
  hash = "sha256-TnPzSysSoSttzD0SSpK6VG6obZNRvWSn/oES1oiFBPE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
