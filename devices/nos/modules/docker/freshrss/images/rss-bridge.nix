pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:5b080be160ac5e5c5a0d450f9e431a472b2ee9e95353d905628ed804efd96783";
  sha256 = "06pzkyyballg5z6ycgfr7biskncayc8asgr3918dmy1mhj7zrmbd";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
