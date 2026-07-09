pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:22c89fe0d0f507606260237fd55e51f6137f58b2d5bcf6152242b96d9fe8f9a4";
  hash = "sha256-JEXRtnqG64R1vW1eIp3T8xSGt9Wn0U3exJVQdEmUGIo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
