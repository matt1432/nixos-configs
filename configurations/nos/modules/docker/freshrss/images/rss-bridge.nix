pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:a536d4d24f7325204652be2a37fb5b25532c618817657d7e31dfc0c1dc7f8d94";
  hash = "sha256-xo0Oi9WAHA1AU+EuM0Ou5wc/+NEK8c8qxZLCpK3DZNU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
