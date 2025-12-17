pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:f3ecbc8c5bfb3bd43fec598d6abf0935fc3ff9e5b8dc5631598fecc0f1935508";
  hash = "sha256-3BVZ0ywaDW7AOCgQ514hjt3ovOViW2ahQYDRFF7+Wjc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
