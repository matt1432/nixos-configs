pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:ae46a8452f2c137766c9d4a62f4fe60166355ff8b00512e6c48692dbf1eed3d5";
  hash = "sha256-np1w6YUYauS7LEOSYbC+02AxNrp4jpVW86EJ/YUQksQ=";
  finalImageName = imageName;
  finalImageTag = "14";
}
