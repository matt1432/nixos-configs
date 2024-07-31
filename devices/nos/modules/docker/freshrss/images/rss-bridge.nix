pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:6161fe1fef70ad077dcae364164d7739c9c0d76bbc7f154dd64a2352fc93f291";
  sha256 = "1yx2wgr32y4dfjf317ks0rvqf863bvsvw5ydl8y55dbbshp6s916";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
