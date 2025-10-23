pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:243f71f3d081feef552b291dad715cdf583fe0ecdc166f01b69d00eab29b5bb1";
  hash = "sha256-uevDpBdtWlXSYwhYV7xPn2riKTMDdUB+7EnrCzYOMOk=";
  finalImageName = imageName;
  finalImageTag = "14";
}
