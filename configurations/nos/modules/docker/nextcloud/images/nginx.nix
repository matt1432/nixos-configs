pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:0a399eb16751829e1af26fea27b20c3ec28d7ab1fb72182879dcae1cca21206a";
  hash = "sha256-ffnlb1m2YeAr9Nj4oSYINmGTrvcazCuEMQaws6jCjpA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
