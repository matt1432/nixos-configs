pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:f055b09e632d40c562d80e1078c21362d720d3c8c040f65edf6cb609229f09d3";
  sha256 = "0rsqcxqx77r4z8xw15sqydp1r2mz129r36c7p43vjv6p2cxyl8sg";
  finalImageName = "postgres";
  finalImageTag = "14";
}
