pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:e13b87cd36a828237d9e284e66ca6fb55e1d9819d6c925e35a689e6b529aeb39";
  sha256 = "018avq5n6k33q3njm606rb5p2sxdfpc07llnl776yn4zvff4516h";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
