pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:e6453b01f22a880a4205d22d537a7a638dd5f21294e74104260c8f72fb24cb82";
  sha256 = "066j7lz32ii1mp12mm4yykfqm4iiyg56p6iqbjs2yhwg7qbnsqbb";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
