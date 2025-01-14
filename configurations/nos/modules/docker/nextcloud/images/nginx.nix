pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:2300fb715ab3a2595a3e6956db7379d25b2815973416e6261dde607ca3a86370";
  hash = "sha256-ffnlb1m2YeAr9Nj4oSYINmGTrvcazCuEMQaws6jCjpA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
