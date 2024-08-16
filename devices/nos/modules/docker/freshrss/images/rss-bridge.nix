pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:3bde3fa44e79c0bd3ed02b45e9e96456ef428cb3421a057f3dfbf310b9b1728d";
  sha256 = "0slcnvhdkzkrvsx797rkly55ibw4schknnw6rw59v4f4kr7sn9s2";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
