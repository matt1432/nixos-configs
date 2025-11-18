pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:5fa127d1beb69d47d871fc4cffacfc5c8b1d8e18c3f37a74b8c1aeabca16c000";
  hash = "sha256-5nMQkqHlrKngP0DukcIN7ZV9xRS/ZLLXp+VSN0KnXwI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
