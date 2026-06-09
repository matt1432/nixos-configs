pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:7d85d0eda291f1a7ab6df4a9d1802b5ad4cf9145a088bd11188c78dcb5c7392b";
  hash = "sha256-xI8hqAQhHV9PTgo5g8SCXfuubmNVyd5+ofatedTUqRo=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
