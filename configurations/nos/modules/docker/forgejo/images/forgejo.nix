pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:db04c7114b656f896e206ba3873fe8d3a7adf2daa44907037f0274f4ba653fb9";
  hash = "sha256-ZR7tPMbEf3tkDRlrkh5JYVMCAXPJVYTe1S3XCFpZwvc=";
  finalImageName = imageName;
  finalImageTag = "15";
}
