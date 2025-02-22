pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:0c39cbac2c87f0342f38f55cb1f3414726237086b3ab588ddbab3c81a8e08e0a";
  hash = "sha256-QmGYxoktVGo53TD/TalCeqQKFwz7uaawi1MLXFtU6E8=";
  finalImageName = imageName;
  finalImageTag = "14";
}
