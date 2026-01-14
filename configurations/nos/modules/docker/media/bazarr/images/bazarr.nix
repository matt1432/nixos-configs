pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:7d0a091a63889ce1e4ac4c90595ebd2c50ba5a5df7039a4f4d2be6c2aed6d4ae";
  hash = "sha256-lPLBmIVuMeOzDZqZqkAbKbV1fPy56Qdz0HX8enxxOOc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
