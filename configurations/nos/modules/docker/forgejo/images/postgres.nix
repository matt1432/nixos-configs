pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:e7e9c0b3470ebff1b693f3a0a3302eb02505e62d67fc1b42c86c2811b4c6e451";
  hash = "sha256-xtZoNaUY8wUtULhtlrljcqp+zPJ3KZGtE4ielPa/u4s=";
  finalImageName = imageName;
  finalImageTag = "14";
}
