pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:0f919cc552b9a894851a944509d9da238f1c1ae5030f293b61c9fcf86a6191b3";
  hash = "sha256-5Xj9YhdeqHk4/ERC/Por/pqap3fJ+LrsXT9CNX1HBZE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
