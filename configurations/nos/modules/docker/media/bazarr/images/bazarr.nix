pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:59f4d72d433a837f4bb22c8cbb58e26ec63716da2ec4c23d2dd8fef55a804a85";
  hash = "sha256-rEMQdG6YuIaRNnesi6Diy2OQJOFA5E83NnHzjMv3vPY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
