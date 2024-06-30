pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:522e520bfd118592ae1a4b0b7c866eb5c3de8cab7827edfa737d886e0c3809f6";
  sha256 = "1qri4rcn7ivxj9gcmcchc3pxrpb2xpm7ph11ikdq9hzlrrbi0646";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
