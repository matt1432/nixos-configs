pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:761f73534a01aec4bf72a1396e9b9fda3f01632948b3fa31985982d26120a330";
  hash = "sha256-XNVngLcovvO2PEZXnvi1xIL6i/f70gNzfivbJbrIkJM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
