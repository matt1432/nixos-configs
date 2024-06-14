pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:e1040b00324d3b3e660beefe91f21d8fd632fb338a11150ae9ec482b9bcd33fe";
  sha256 = "1ffwzrmxhlhhm4vgypv24j716l1wyr6nn4iz2icc1g2a0ywzi0bi";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
