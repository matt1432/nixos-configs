pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:0c85646f8c2d6cd285e68f0e7060a545228a13935b5e297b98aea5ef89594ad9";
  hash = "sha256-V4FNy5CWjpKJltvA5o+gWxlptGx64pWi5cgqQONCxsA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
