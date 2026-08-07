pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:2ff34bd8deaa90698be183283b69f5242fcfa451a8e3421344926ffb621c05af";
  hash = "sha256-XhvDF1W5I9j0YhBubAVRmCTeMPqYNkgPvLx3jD3vzPw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
