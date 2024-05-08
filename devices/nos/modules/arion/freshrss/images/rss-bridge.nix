pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:d8dd829020077349eb96403677e21a9eb5930595aa5c419720f6c8148528bdcf";
  sha256 = "1h8jxhsbs0m5jfnznb2jd3zy14g3vjy5iy026r6g6ggxkiw0hrpp";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
