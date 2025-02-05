pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:11c0748af64453e7cce670c47a6f2f7b2f6724ee3c6bf5cd87c7ad85b98e0070";
  hash = "sha256-5EmopZBvKKKpKp8wnrR57wCrBiDPgg5lFlgQGL83OtQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
