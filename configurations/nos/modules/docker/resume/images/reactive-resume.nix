pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:7060b6fca5d4b7f92b75691286dd78a3e718a511cdfb2fc2b980b81a82b0d0b1";
  hash = "sha256-yfTX8+wyo2MqKcq6BIqO9MlQAT/yXnaShbcAkhb8Hy4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
