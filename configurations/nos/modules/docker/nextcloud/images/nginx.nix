pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:5ab5b0b01097420873a3f3330f44248e34a3c2a3e8d5ee30658aeae8cb7435da";
  hash = "sha256-Q1hOn2hwPC8NO5o7uRZEv7yVCZ+xcnr/W0KgCY0U/7c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
