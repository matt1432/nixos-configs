pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:327315251d038d2ddae7eb088569470f52255f8a0cdc4df41eab47dab4624318";
  sha256 = "03w1jnhxahbvlmnby7c5v47sm1ypz98v0w5inm8bdwi765r7db60";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
