pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:70f159c47fb682dffde5a0bd2ea4987f78528e779dd5fdbab11848082a24f11e";
  hash = "sha256-NsacfQyoBhC+wmn3GrG+hGKDJ7dvxELEKui1jJNXW+Y=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
