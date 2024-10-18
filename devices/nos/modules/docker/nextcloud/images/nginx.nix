pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:28402db69fec7c17e179ea87882667f1e054391138f77ffaf0c3eb388efc3ffb";
  sha256 = "0zas3xrxlrr1qd3hc5p63q5hpja3cdfvv6alx10j8q489wn21m0s";
  finalImageName = imageName;
  finalImageTag = "latest";
}
