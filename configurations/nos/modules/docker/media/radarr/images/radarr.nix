pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:fc0ae3c50f8128b97e84381903ec8d6845c3a569641cb7117c124376cccb57c1";
  hash = "sha256-KxEfcj3lEYbfMQzF8eBDOEny8xrd9Y1cYQZAXKmkAaU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
