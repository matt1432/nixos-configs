pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:ad6b604e0cecc917a5cb6a8de55cd167ba415da8b7ec13456abb871a84be3c30";
  hash = "sha256-A0LBc/mzibYKMivddZkVskarsXhLMqlvzHEE1Av72og=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
