pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:655da7086bac287e8b0ae0a5291a8035c30e762978a8bd49501e81bf2f0e1233";
  hash = "sha256-DBjXNimD8LW5xicDb55mEMuP/0ayGX9Fn4g1FTMehAo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
