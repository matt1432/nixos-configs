pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:2ed2ac1c2308f929947b363d0866aa48543600368f6df4f29a004aa0869d9f22";
  sha256 = "075ymqv5z3h902yr32w1dxcpp2az79xqam0lb97c0lkq2dc5hxgb";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
