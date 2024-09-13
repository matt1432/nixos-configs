pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:fada58f35c97d4e50ae045176339722b69397a6803a46c00799a96160db84092";
  sha256 = "0q4hnmy21v9d5fjya0xn9yl4k5yzxm5irwp13scch6rbx2nn7gnc";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
