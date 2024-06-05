pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:d1f0f28335c22331974aea610866c9434ca71c6706d457c32309543d6431708a";
  sha256 = "0v4ihlaphp6zj7clsvlnf57047sdf6zwaq4lhrwd7q6dgdsnxx6k";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
