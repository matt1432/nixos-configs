pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:4fed6d1e549675689a9554f165a26ad3ebf63d0c3673f42429de81927da329a2";
  sha256 = "0rxgw6rbis1l8jb1ayqib902c510prgcvvh3w1i5g68m7di5xxm1";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
