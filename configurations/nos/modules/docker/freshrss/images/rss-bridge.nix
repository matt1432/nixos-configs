pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:1b78c8b4bc74fe1eb1c92e101dfb4d1d3fb278d3c530baff4097febc18f06615";
  hash = "sha256-uQKNakebpm3sM95o8kgtTRzDETB0Ao+003nszO1FlGk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
