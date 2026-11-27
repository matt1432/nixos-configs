pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:2806c9b763810589c42157730d547c293639e55c7610e9f5069314854639ec48";
  hash = "sha256-oHkEWv8ORWDpIhE93f7sD2GCSQzAp9OiCA9t5EG+DZ0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
