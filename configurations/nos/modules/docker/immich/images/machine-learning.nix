pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:b213fa3c82d27a21a299c46ffbb38a091f18384db1ad67d409a3b34fe0fce556";
  hash = "sha256-62pt/2xRPU1litLhx0+5pH29wmWKleSfiN0+aRD+mUg=";
  finalImageName = imageName;
  finalImageTag = "release";
}
