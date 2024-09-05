pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:ed96ae6fb5be49a7c14fc35de039d53f2b42d99034c49c4e28fe0810e3886445";
  sha256 = "0nyycwmrnj65jfsvcna0qjs3viapy98m5yw45qqzrf0gha4f3kpd";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
