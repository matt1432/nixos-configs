pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:8f029c543423e3eac6b08254718bc31eb75633b1e448026b6616927baa7d4bfe";
  hash = "sha256-+Wt2571pze0yhQoSR2IsHBVLLKJUwAnqY6UyMXpz4cY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
