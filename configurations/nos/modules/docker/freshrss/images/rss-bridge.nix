pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:943b0294a9520993cb96934cca52c06f8346aade4ab8aec58c197cff5bc7d983";
  hash = "sha256-xjEYTLMVUXetNKmP5ks/B/8vNkzfFK0QGdzSP+A8gTw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
