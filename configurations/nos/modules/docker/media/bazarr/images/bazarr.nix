pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:aaaa087af75a73b7ac765dcc5d748874cfafdb93c23ec9f64fbb481dea291b23";
  hash = "sha256-I2Rdq+9HwdfcG05oXEMfNkVgWqOea5X5YsMzlHKd0UI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
