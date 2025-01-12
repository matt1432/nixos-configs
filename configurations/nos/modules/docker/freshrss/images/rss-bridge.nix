pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:f2ffb2127499e4c86f001ba5adaa86f80f5167ae4bcea6bdd11401eb0f769224";
  hash = "sha256-b1RneJXa1393nZxPSsB+nyTPoJOu5mFhWnKhQ+xEpn8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
