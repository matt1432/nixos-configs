pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:563a4985838fcb5ac2e60fd58a1055ceafa791665e75e18d236221af0d478a33";
  hash = "sha256-FNq9tSkbaHf9wt2oxVl8mT6bWjFoRm+czpIIyIPjXA4=";
  finalImageName = imageName;
  finalImageTag = "14";
}
