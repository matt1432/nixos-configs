pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:2bab77914c547f93b346d8c9b9c30b60e420aa7d4f3a002f637d02b679b0902b";
  sha256 = "026d068qgrqcv1b9gs3hd3i6h5azc1bcggv9p6k3cpw8nqk237ky";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
