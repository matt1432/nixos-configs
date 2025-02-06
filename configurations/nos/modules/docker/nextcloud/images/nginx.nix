pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:91734281c0ebfc6f1aea979cffeed5079cfe786228a71cc6f1f46a228cde6e34";
  hash = "sha256-6VObrj1Sg4DabuQYl9aOpQhZo4OG1LnsYjeIoMKtSps=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
