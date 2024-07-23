pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:0c9b69b804edbfd211b8cdfc87ac4c79db52dbcc8fb8c278d07136db2f79fe6c";
  sha256 = "0rsqcxqx77r4z8xw15sqydp1r2mz129r36c7p43vjv6p2cxyl8sg";
  finalImageName = "postgres";
  finalImageTag = "14";
}
