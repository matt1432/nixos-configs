pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:df734e97e2aed1a5d03b9b0d2fede9faf5bea9d1ad0c15a3c469ac303e681084";
  hash = "sha256-a+rwPi8qqwjMC5ePZtWsiOvYKkPDJ1WSzDU/tMxD190=";
  finalImageName = imageName;
  finalImageTag = "14";
}
