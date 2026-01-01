pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:1816c4bcec1f9b7c6b447d50dde798ce7fd6ca656be9537c77c162d16780079a";
  hash = "sha256-3P69f6h0KMLWGQOeUbeIIckGzdzHgQWe5rO8P1PFUIE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
