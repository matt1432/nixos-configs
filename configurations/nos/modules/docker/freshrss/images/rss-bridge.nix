pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:4f37a3e507af7cb53acbe788ba356de745f936bb02eb623deef14e147a942145";
  hash = "sha256-6viRDTT/RcqCZDYT81T6980M04T5oeI2smy1uP88fkg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
