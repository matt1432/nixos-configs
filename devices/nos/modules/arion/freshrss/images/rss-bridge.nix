pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:dd61e31c31e2d2a7ad1869ef27e2dede546e80ddd821655a0b2cbc018c2dffc6";
  sha256 = "123a8nfq2y6qf8qcg9rfg1amp3mwpvhxdsmwyf92k63ywqrymb5x";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
