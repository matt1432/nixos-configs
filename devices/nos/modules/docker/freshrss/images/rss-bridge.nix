pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:46d13f894d325fae4202a42d91a7f4693c12f8db46d8c8a4aeadd17ff4c961a7";
  sha256 = "16qc02dlh0yksp69gd3c74d6d4km2zqyrbgm63d5f8gc0m2k7ivs";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
