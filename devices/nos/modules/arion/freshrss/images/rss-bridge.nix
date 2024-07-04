pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:7959360e979ef467242c80beec6c1c4d8e69561aedaa87a73c4c905fce74108a";
  sha256 = "0ykd67iddg3b7saz9pqdzkn9py3sxaf0mn8wc6jfml9vq98q3mkn";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
