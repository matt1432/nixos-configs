pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:11abfc3f53b02f6099db1fb0e202b41be3ec66698180da9eb8cfad0ce55051cd";
  sha256 = "0rsqcxqx77r4z8xw15sqydp1r2mz129r36c7p43vjv6p2cxyl8sg";
  finalImageName = "postgres";
  finalImageTag = "14";
}
