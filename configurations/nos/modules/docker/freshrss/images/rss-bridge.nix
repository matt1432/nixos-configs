pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:ba9ba4b03e446982e2f7373663e1d08a1bb3111f8932c1e8e5f795bfce03b33b";
  hash = "sha256-ZXP0AGLiCgYsAe5Ggme0kYJ1flDe/QPNrenF+O+9WgY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
