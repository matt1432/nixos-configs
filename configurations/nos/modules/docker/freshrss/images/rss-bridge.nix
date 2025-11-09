pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:183d8e3741959f7d5eb993e536009be4c79b526b1e9b31fd9b2fde3edb0ba4fe";
  hash = "sha256-khgFUHVk8VNDQAZHMWtDJiV6zKUKt9wyGFRKthOBAgU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
