pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:156f0b253fd61366d5fc2107ad45955027d5612f695a8436ce20167f3fa79bff";
  hash = "sha256-itzTCEa9LP3i7xOXSNH/k8KVb5ayNPMKt/XJQXJepic=";
  finalImageName = imageName;
  finalImageTag = "14";
}
