pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:92315a943dc4b40ea9ecddd5c49ab9cb4a82e2e6aa5097a6069ffc016934f508";
  hash = "sha256-+/B4dFYoWjFP6NlFYyAI7PluTMrLjZ9rUZzjstHHwrE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
