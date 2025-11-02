pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:27d106cb48111add22c0d9f20d7bb820b7c6c6ddc090cac96f40e4222c4ae6cf";
  hash = "sha256-BiXz3qpR8qZFB0Pytx1gTIEsmWqKl5Zn4oI9kossazI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
