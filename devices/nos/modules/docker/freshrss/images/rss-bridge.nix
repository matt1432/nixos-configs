pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:311b80e213d3f73bfac81987aac3fbf71c521625df5f67ee2e1e83328b509e1e";
  sha256 = "1gzpjsdpf1acnrv2ybay6b5q8fidwy5zd7hpdrxzdq0z46l4hb66";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
