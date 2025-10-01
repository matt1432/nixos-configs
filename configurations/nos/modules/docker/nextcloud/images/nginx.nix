pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:8adbdcb969e2676478ee2c7ad333956f0c8e0e4c5a7463f4611d7a2e7a7ff5dc";
  hash = "sha256-yKKEXFfznsgIeQgu3xyeeqw7ylexJsk5JxSxhe1HVGo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
