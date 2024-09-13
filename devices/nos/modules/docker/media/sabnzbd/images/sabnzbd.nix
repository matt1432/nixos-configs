pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:cf7743af338e1cdfc97f6e6c605c8c45d737a4f268ab96ba6cec565134cea5e1";
  sha256 = "1d40g8q8wmwz5pdmh2rgmbm9ysj21vkcanzcjp5fljiz55fvmrpa";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
