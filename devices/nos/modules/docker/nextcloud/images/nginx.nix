pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:6af79ae5de407283dcea8b00d5c37ace95441fd58a8b1d2aa1ed93f5511bb18c";
  sha256 = "0i2q2aaa8qn5zgvil9gbyvj6yazprvgi6z23jp0xaskkpm24qvfy";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
